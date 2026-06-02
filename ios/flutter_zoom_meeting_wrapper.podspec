#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_zoom_meeting_wrapper.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_zoom_meeting_wrapper'
  s.version          = '0.0.2'
  s.summary          = 'A Flutter plugin to integrate Zoom Meeting SDK directly in your app.'
  s.description      = <<-DESC
A Flutter plugin to integrate Zoom Meeting SDK directly in your app.
Join meetings without switching to the Zoom app. Simple initialization with JWT authentication.
                       DESC
  s.homepage         = 'https://github.com/DevCodeSpace/flutter_zoom_meeting_wrapper'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DevCodeSpace' => 'pubdev@devcodespace.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.frameworks = [
    'UIKit',
    'Foundation',
    'AVFoundation',
    'ReplayKit',
    'VideoToolbox',
    'CoreMedia',
    'CoreVideo'
  ]
  # Zoom Meeting SDK - place MobileRTC.xcframework, zoomcml.framework/xcframework,
  # and any other companion Zoom frameworks from the same iOS Meeting SDK zip
  # into ios/Frameworks/. MobileRTC has runtime @rpath dependencies on these
  # companion frameworks, so they must be embedded in the app bundle too.
  s.vendored_frameworks = [
    'Frameworks/*.xcframework',
    'Frameworks/*.framework'
  ]

  # Copy MobileRTCResources.bundle into the host app bundle so MobileRTC can
  # find it at runtime via Bundle.main.bundlePath (the standard Zoom SDK pattern).
  s.resources = ['Frameworks/MobileRTCResources.bundle']

  s.prepare_command = <<-CMD
    if [ ! -d "Frameworks/zoomcml.framework" ] && [ ! -d "Frameworks/zoomcml.xcframework" ]; then
      echo "error: Missing Zoom dependency: ios/Frameworks/zoomcml.framework or ios/Frameworks/zoomcml.xcframework"
      echo "Copy it from the same Zoom iOS Meeting SDK package as MobileRTC.xcframework, then run pod install again."
      exit 1
    fi
  CMD

  # The bundled Zoom Meeting SDK xcframework contains arm64 slices only,
  # including for the iOS simulator. Excluding x86_64 lets CocoaPods select
  # the simulator slice and makes the MobileRTC module available to Swift.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 x86_64'
  }
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 x86_64'
  }
  s.swift_version = '5.0'
end
