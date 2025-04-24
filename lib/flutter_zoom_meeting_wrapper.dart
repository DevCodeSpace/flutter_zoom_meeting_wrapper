import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZoomMeetingWrapper {
  static const MethodChannel _channel = MethodChannel(
    'flutter_zoom_meeting_wrapper',
  );

  /// Initialize the Zoom SDK with JWT token
  ///
  /// Returns a [Future] that completes with true if the initialization was successful
  static Future<bool> initZoom(String jwt) async {
    try {
      var result = await _channel.invokeMethod('initZoom', {'jwt': jwt});
      return result;
    } catch (e) {
      debugPrint('Error initializing Zoom SDK: $e');
      return false;
    }
  }

  /// Join a Zoom meeting
  ///
  /// Parameters:
  /// - [meetingId]: The ID of the meeting to join
  /// - [meetingPassword]: The password for the meeting
  /// - [displayName]: The name to display in the meeting
  ///
  /// Returns a [Future] that completes with true if joining the meeting was successful
  static Future<bool> joinMeeting({
    required String meetingId,
    required String meetingPassword,
    required String displayName,
  }) async {
    try {
      final result = await _channel.invokeMethod('joinMeeting', {
        'meetingId': meetingId,
        'meetingPassword': meetingPassword,
        'displayName': displayName,
      });
      return result ?? false;
    } catch (e) {
      debugPrint('Error joining Zoom meeting: $e');
      return false;
    }
  }
}
