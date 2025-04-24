import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'flutter_zoom_meeting_wrapper_platform_interface.dart';

/// An implementation of [ZoomMeetingWrapperPlatform] that uses method channels.
/// This class provides the method channel implementation for communicating
/// with the native platform (iOS/Android) to handle Zoom SDK operations.
class ZoomMeetingWrapperMethodChannel extends ZoomMeetingWrapperPlatform {
  /// The method channel used to interact with the native platform.
  /// This establishes a communication channel with the native code
  /// using the channel name 'flutter_zoom_meeting_wrapper'.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_zoom_meeting_wrapper');

  /// Initializes the Zoom SDK with the provided JWT token.
  ///
  /// Takes a [jwt] token that is required for authenticating with Zoom services.
  /// Returns a [Future<bool>] indicating whether the initialization was successful.
  ///
  /// Throws and catches any exceptions that might occur during initialization,
  /// printing the error to the debug console and returning false.
  @override
  Future<bool> initZoom(String jwt) async {
    try {
      // Invoke the native platform's 'initZoom' method with the JWT token
      await methodChannel.invokeMethod<bool>('initZoom', {'jwt': jwt});
      return true;
    } catch (e) {
      // Log any errors that occur during initialization
      debugPrint('Error initializing Zoom SDK: $e');
      return false;
    }
  }

  /// Joins a Zoom meeting with the specified credentials.
  ///
  /// Requires:
  /// - [meetingId]: The unique identifier for the Zoom meeting
  /// - [meetingPassword]: The password required to join the meeting
  /// - [displayName]: The name to be displayed for the participant
  ///
  /// Returns a [Future<bool>] indicating whether joining the meeting was successful.
  ///
  /// Handles any exceptions that might occur during the join process,
  /// printing the error to the debug console and returning false.
  @override
  Future<bool> joinMeeting({
    required String meetingId,
    required String meetingPassword,
    required String displayName,
  }) async {
    try {
      // Invoke the native platform's 'joinMeeting' method with the meeting details
      final result = await methodChannel.invokeMethod<bool>('joinMeeting', {
        'meetingId': meetingId,
        'meetingPassword': meetingPassword,
        'displayName': displayName,
      });
      // Return the result, defaulting to false if null
      return result ?? false;
    } catch (e) {
      // Log any errors that occur while joining the meeting
      debugPrint('Error joining Zoom meeting: $e');
      return false;
    }
  }
}
