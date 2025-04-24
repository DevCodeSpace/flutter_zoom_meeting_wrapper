import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_meeting_wrapper/flutter_zoom_meeting_wrapper.dart'; // Zoom SDK wrapper

// Main entry point for the application
void main() {
  runApp(const MyApp());
}

// Stateful widget for the main application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// State class for the MyApp widget
class _MyAppState extends State<MyApp> {
  // Text controllers for the various input fields
  final _jwtController = TextEditingController(); // For JWT token
  final _meetingIdController = TextEditingController(); // For Zoom meeting ID
  final _meetingPasswordController =
      TextEditingController(); // For meeting password
  final _displayNameController =
      TextEditingController(); // For user's display name

  // State variables to track Zoom SDK initialization and status
  bool _isInitialized = false; // Tracks if Zoom SDK is initialized
  String _statusMessage =
      'Not initialized'; // Status message to display to user

  @override
  void initState() {
    super.initState();
    // Pre-fill display name field for user convenience
    _displayNameController.text = 'Flutter User';
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _jwtController.dispose();
    _meetingIdController.dispose();
    _meetingPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  // Method to initialize the Zoom SDK with a JWT token
  Future<void> _initZoom() async {
    // Validate JWT token presence
    if (_jwtController.text.isEmpty) {
      setState(() {
        _statusMessage = 'JWT token is required';
      });
      return;
    }

    try {
      // Attempt to initialize the Zoom SDK
      final result = await ZoomMeetingWrapper.initZoom(_jwtController.text);
      setState(() {
        _isInitialized = result;
        _statusMessage =
            result
                ? 'Zoom SDK initialized successfully'
                : 'Failed to initialize Zoom SDK';
      });
    } catch (e) {
      // Handle any exceptions during initialization
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  // Method to join a Zoom meeting
  Future<void> _joinMeeting() async {
    // Check if SDK is initialized first
    if (!_isInitialized) {
      setState(() {
        _statusMessage = 'Please initialize Zoom SDK first';
      });
      return;
    }

    // Validate that all required fields are filled
    if (_meetingIdController.text.isEmpty ||
        _meetingPasswordController.text.isEmpty ||
        _displayNameController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Meeting ID, password, and display name are required';
      });
      return;
    }

    try {
      // Attempt to join the meeting with provided credentials
      final result = await ZoomMeetingWrapper.joinMeeting(
        meetingId: _meetingIdController.text,
        meetingPassword: _meetingPasswordController.text,
        displayName: _displayNameController.text,
      );

      // Update UI based on join result
      setState(() {
        _statusMessage =
            result ? 'Joined meeting successfully' : 'Failed to join meeting';
      });
    } catch (e) {
      // Handle any exceptions during joining
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  // Helper method to generate a Zoom JWT token using API credentials
  String generateZoomJWT(String apiKey, String apiSecret) {
    // Create a new JWT with required claims
    final jwt = JWT({
      'appKey': apiKey, // Zoom API key
      "iat":
          DateTime.now().millisecondsSinceEpoch ~/
          1000, // Issued at time (current time)
      'exp': // Expiration time (1 hour from now)
          DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
          1000,
      'tokenExp': // Token expiration (1 hour from now)
          DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
          1000,
    });

    // Sign the JWT with the API secret using HMAC-SHA256 algorithm
    final token = jwt.sign(SecretKey(apiSecret), algorithm: JWTAlgorithm.HS256);
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Zoom SDK Example')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status display container with color based on initialization state
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color:
                      _isInitialized
                          ? Colors.green.shade100
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Status: $_statusMessage',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        _isInitialized ? Colors.green.shade800 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Step 1: JWT Token Generation Section
              const Text(
                'Step 1: Generate JWT Token',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Auto-generate JWT token with placeholder credentials
                  // Replace "ZOOM-CLIENT-KEY" and "ZOOM-CLIENT-SECRET" with actual credentials
                  _jwtController.text = generateZoomJWT(
                    "ZOOM-CLIENT-KEY",
                    "ZOOM-CLIENT-SECRET",
                  );
                  setState(() {});
                },
                child: const Text('Generate JWT'),
              ),
              const SizedBox(height: 24),

              // Step 2: SDK Initialization Section
              const Text(
                'Step 2: Initialize Zoom SDK',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _jwtController,
                decoration: const InputDecoration(
                  labelText: 'JWT Token',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Zoom JWT token',
                ),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _initZoom, // Call _initZoom method on press
                child: const Text('Initialize Zoom SDK'),
              ),
              const SizedBox(height: 24),

              // Step 3: Meeting Join Section
              const Text(
                'Step 3: Join Meeting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _meetingIdController,
                decoration: const InputDecoration(
                  labelText: 'Meeting ID',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the meeting ID',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _meetingPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Password',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the meeting password',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your display name',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _joinMeeting, // Call _joinMeeting method on press
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Join Meeting'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
