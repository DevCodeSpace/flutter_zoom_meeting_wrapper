# 📱 Flutter Zoom Meeting Wrapper

A Flutter plugin that allows you to integrate the Zoom Meeting SDK into your Flutter application. This plugin enables users to join Zoom meetings directly within your app without switching to the Zoom app.

<img src="assets/banner.png" alt="Zoom Meeting Banner" />

## ✨ Features

🚀 Easy integration with the Zoom Meeting SDK  
🔄 Initialize SDK using a JWT token  
🎯 Join meetings directly within your app (no Zoom app required)  
📱 Android platform support  
🔊 Full audio and video meeting experience  
🔐 Secure authentication flow via JWT  


## 📦 Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_zoom_meeting_wrapper: ^0.0.1
```
---
## ⚙️ Mandatory Zoom SDK Setup

Follow these steps to properly set up the Zoom SDK:

1. Add the dependency and run `flutter pub get`.
2. Download the Zoom SDK ZIP from the following link:  
   👉 [Zoom SDK Download](https://drive.google.com/file/d/1aKhrS5JCVSxvQkfdXH0N1h45Lk2gt6P9/view?usp=sharing)
3. Extract the ZIP file after downloading.
4. Copy the `libs` folder and paste it inside your Flutter pub-cache directory at:
   ```
   ~/.pub-cache/hosted/pub.dev/flutter_zoom_meeting_wrapper-0.0.1/android/
   ```
   > 🔁 Replace `0.0.1` with the version you’re using, if different.

5. Or run the following command to open the folder directly:
   ```bash
   open ~/.pub-cache/hosted/pub.dev/flutter_zoom_meeting_wrapper-0.0.1/android
   ```

> ⚠️ **Important:** The `libs` folder **must** be placed in the correct location for the plugin to function properly.

---


## 🔑 Getting Started with Zoom SDK

1. Create a Zoom Developer Account at [https://marketplace.zoom.us/](https://marketplace.zoom.us/)
2. Create an app in the Zoom Marketplace
3. Get your API Key and API Secret from the app credentials
4. Use these to generate your JWT token

---

## 🔒 Generate JWT Token
To generate a ZOOM JWT token, you can use https://jwt.io/ with the following payload and signature:
Payload:
```json
{
  "appKey": "ZOOM-CLIENT-KEY",
  "iat": ANY-TIME-STAMP, 
  "exp": ANY-TIME-STAMP, //greater than iat
  "tokenExp": ANY-TIME-STAMP //greater than iat
}
```

Verify Signature:
```
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  "ZOOM-CLIENT-SECRET"
)
```

## 🚀 Usage

### Initialize the SDK

First, initialize the Zoom SDK with your JWT token:

```dart
import 'package:flutter_zoom_meeting_wrapper/flutter_zoom_meeting_wrapper.dart';

// Initialize Zoom SDK

bool isInitialized = await ZoomMeetingWrapper.initZoom(jwtToken);
```

### Join a Meeting

Once initialized, you can join a Zoom meeting like this:

```dart
bool joinSuccess = await ZoomMeetingWrapper.joinMeeting(
  meetingId: "your_meeting_id",
  meetingPassword: "meeting_password",
  displayName: "Your Name",
);
```

### ⚠️ Common Issues

**JWT Token Invalid**: Ensure your API Key and Secret are correct, and check that your system time is accurate.<br>
**Failed to initialize SDK**: Make sure you have a stable internet connection and valid JWT token. <br>
**Cannot join meeting**: Verify that the meeting ID and password are correct.

## ⚡ Limitations

🖼️ Custom UI overlays are not supported in the current version <br>
📹 Recording meetings is not supported in this plugin <br>
🖥️ Screen sharing functionality is limited to platform capabilities

## 👨‍💻 Code Contributors

<img src="assets/contributors.png" width="230" alt="Zoom Meeting Wrapper contributors" />







