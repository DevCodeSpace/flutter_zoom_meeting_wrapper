import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_zoom_meeting_wrapper/flutter_zoom_meeting_wrapper_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ZoomMeetingWrapperMethodChannel platform = ZoomMeetingWrapperMethodChannel();
  const MethodChannel channel = MethodChannel('flutter_zoom_meeting_wrapper');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'initZoom') return true;
          if (methodCall.method == 'joinMeeting') return true;
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initZoom returns true on success', () async {
    expect(await platform.initZoom('test_jwt'), true);
  });

  test('joinMeeting returns true on success', () async {
    expect(
      await platform.joinMeeting(
        meetingId: '123456789',
        meetingPassword: 'password',
        displayName: 'Test User',
      ),
      true,
    );
  });
}
