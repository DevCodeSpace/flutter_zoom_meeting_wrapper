import Flutter
import UIKit
import MobileRTC

public class FlutterZoomMeetingWrapperPlugin: NSObject, FlutterPlugin, MobileRTCAuthDelegate, MobileRTCMeetingServiceDelegate {

  private var authResult: FlutterResult?
  private var joinResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_zoom_meeting_wrapper", binaryMessenger: registrar.messenger())
    let instance = FlutterZoomMeetingWrapperPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initZoom":
      guard let args = call.arguments as? [String: Any],
            let jwt = args["jwt"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing JWT token", details: nil))
        return
      }
      initializeZoom(jwt: jwt, result: result)

    case "joinMeeting":
      guard let args = call.arguments as? [String: Any],
            let meetingId = args["meetingId"] as? String,
            let password = args["meetingPassword"] as? String,
            let displayName = args["displayName"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing meeting parameters", details: nil))
        return
      }
      startJoinMeeting(meetingId: meetingId, password: password, displayName: displayName, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Zoom SDK

  // Find the directory that contains MobileRTCResources.bundle using FileManager so the
  // result is a plain filesystem path identical to what Zoom docs show (Bundle.main.bundlePath).
  // CocoaPods places the bundle in the main app bundle (static integration) or inside the
  // plugin framework (use_frameworks!), so we check both.
private func mobileRTCResourcesBundlePath() -> String? {

    if let path = Bundle.main.path(
        forResource: "MobileRTCResources",
        ofType: "bundle"
    ) {
        return path
    }

    if let path = Bundle(for: MobileRTC.self).path(
        forResource: "MobileRTCResources",
        ofType: "bundle"
    ) {
        return path
    }

    if let path = Bundle(for: FlutterZoomMeetingWrapperPlugin.self).path(
        forResource: "MobileRTCResources",
        ofType: "bundle"
    ) {
        return path
    }

    return nil
}

  private func initializeZoom(jwt: String, result: @escaping FlutterResult) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      let sdk = MobileRTC.shared()
      
      // SDK already authorized — no need to re-initialize
      if sdk.isRTCAuthorized() {
        result(true)
        return
      }

      guard let resPath = self.mobileRTCResourcesBundlePath() else {
        result(FlutterError(code: "INIT_ERROR", message: "MobileRTCResources.bundle not found in app bundle. Ensure it is listed in the podspec resources and pod install was run.", details: nil))
        return
      }

      let context = MobileRTCSDKInitContext()
      context.domain = "zoom.us"
      context.enableLog = true
      let frameworkBundle = Bundle(for: MobileRTC.self)
      context.bundleResPath = frameworkBundle.bundlePath
     
        
        let initResult = sdk.initialize(context)
        

        guard initResult else {
        result(FlutterError(code: "INIT_ERROR", message: "MobileRTC.initialize() returned false", details: nil))
        return
      }
     
      guard let authService = sdk.getAuthService() else {
        result(FlutterError(code: "INIT_ERROR", message: "Could not get MobileRTC auth service", details: nil))
        return
      }

      self.authResult = result
      authService.delegate = self
      authService.jwtToken = jwt
      authService.sdkAuth()
    }
  }

  private func startJoinMeeting(meetingId: String, password: String, displayName: String, result: @escaping FlutterResult) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      guard MobileRTC.shared().isRTCAuthorized() else {
        result(FlutterError(code: "SDK_ERROR", message: "Zoom SDK is not initialized. Call initZoom first.", details: nil))
        return
      }

      guard let meetingService = MobileRTC.shared().getMeetingService() else {
        result(FlutterError(code: "SDK_ERROR", message: "Could not get MobileRTC meeting service", details: nil))
        return
      }

      guard let scene = UIApplication.shared.connectedScenes
        .first(where: { $0.activationState == .foregroundActive }) else {
        result(FlutterError(code: "SDK_ERROR", message: "No active foreground scene found", details: nil))
        return
      }

      MobileRTC.shared().setMobileRTCPresentationScene(scene)
      meetingService.delegate = self
      self.joinResult = result

      let params = MobileRTCMeetingJoinParam()
      params.meetingNumber = meetingId
      params.password = password
      params.userName = displayName

      let joinError = meetingService.joinMeeting(with: params)
      if joinError != .success {
        self.joinResult = nil
        result(FlutterError(
          code: "JOIN_ERROR",
          message: "joinMeeting returned error code: \(joinError.rawValue)",
          details: nil))
      }
      // On .success the result is delivered via onMeetingStateChange delegate
    }
  }

  // MARK: - MobileRTCAuthDelegate

  public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
    guard let result = authResult else { return }
    authResult = nil

    DispatchQueue.main.async {
      if returnValue == .success {
        result(true)
      } else {
        result(FlutterError(code: "AUTH_ERROR", message: "Zoom auth failed with error: \(returnValue.rawValue)", details: nil))
      }
    }
  }

  public func onMobileRTCAuthExpired() {
    authResult = nil
  }

  // MARK: - MobileRTCMeetingServiceDelegate

  public func onMeetingStateChange(_ state: MobileRTCMeetingState) {
    guard let result = joinResult else { return }

    switch state {
    case .inMeeting:
      joinResult = nil
      DispatchQueue.main.async { result(true) }
    case .failed, .ended, .disconnecting:
      joinResult = nil
      DispatchQueue.main.async {
        result(FlutterError(code: "JOIN_ERROR", message: "Meeting ended or failed. State: \(state.rawValue)", details: nil))
      }
    default:
      break
    }
  }

  public func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
    guard let result = joinResult else { return }
    if error != .success {
      joinResult = nil
      DispatchQueue.main.async {
        result(FlutterError(
          code: "JOIN_ERROR",
          message: "Meeting error \(error.rawValue): \(message ?? "")",
          details: nil))
      }
    }
  }
}
