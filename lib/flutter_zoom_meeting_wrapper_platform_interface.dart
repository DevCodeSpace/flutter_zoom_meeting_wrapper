import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_zoom_meeting_wrapper_method_channel.dart';

abstract class ZoomMeetingWrapperPlatform extends PlatformInterface {
  /// Constructs a ZoomMeetingWrapperPlatform.
  ZoomMeetingWrapperPlatform() : super(token: _token);

  static final Object _token = Object();
  static ZoomMeetingWrapperPlatform _instance =
      ZoomMeetingWrapperMethodChannel();

  /// The default instance of [ZoomMeetingWrapperPlatform] to use.
  static ZoomMeetingWrapperPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZoomMeetingWrapperPlatform] when
  /// they register themselves.
  static set instance(ZoomMeetingWrapperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the Zoom SDK with JWT token
  Future<bool> initZoom(String jwt) {
    throw UnimplementedError('initZoom() has not been implemented.');
  }

  /// Joins a Zoom meeting
  Future<bool> joinMeeting({
    required String meetingId,
    required String meetingPassword,
    required String displayName,
  }) {
    throw UnimplementedError('joinMeeting() has not been implemented.');
  }
}
