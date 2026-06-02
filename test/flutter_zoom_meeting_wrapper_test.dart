import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_zoom_meeting_wrapper/flutter_zoom_meeting_wrapper_platform_interface.dart';
import 'package:flutter_zoom_meeting_wrapper/flutter_zoom_meeting_wrapper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZoomMeetingWrapperPlatform
    with MockPlatformInterfaceMixin
    implements ZoomMeetingWrapperPlatform {
  @override
  Future<bool> initZoom(String jwt) => Future.value(true);

  @override
  Future<bool> joinMeeting({
    required String meetingId,
    required String meetingPassword,
    required String displayName,
  }) => Future.value(true);
}

void main() {
  final ZoomMeetingWrapperPlatform initialPlatform =
      ZoomMeetingWrapperPlatform.instance;

  test('$ZoomMeetingWrapperMethodChannel is the default instance', () {
    expect(initialPlatform, isInstanceOf<ZoomMeetingWrapperMethodChannel>());
  });

  test('initZoom returns true with mock platform', () async {
    MockZoomMeetingWrapperPlatform fakePlatform =
        MockZoomMeetingWrapperPlatform();
    ZoomMeetingWrapperPlatform.instance = fakePlatform;

    expect(
      await ZoomMeetingWrapperPlatform.instance.initZoom('test_jwt'),
      true,
    );
  });

  test('joinMeeting returns true with mock platform', () async {
    MockZoomMeetingWrapperPlatform fakePlatform =
        MockZoomMeetingWrapperPlatform();
    ZoomMeetingWrapperPlatform.instance = fakePlatform;

    expect(
      await ZoomMeetingWrapperPlatform.instance.joinMeeting(
        meetingId: '123456789',
        meetingPassword: 'password',
        displayName: 'Test User',
      ),
      true,
    );
  });
}
