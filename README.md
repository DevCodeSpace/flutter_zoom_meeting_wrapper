# 📱 Flutter Zoom Meeting Wrapper

A Flutter plugin that allows you to integrate the Zoom Meeting SDK into your Flutter application. This plugin enables users to join Zoom meetings directly within your app without switching to the Zoom app.

<img src="https://raw.githubusercontent.com/DevCodeSpace/flutter_zoom_meeting_wrapper/refs/heads/main/assets/banner.png" alt="Zoom Meeting Banner" />

## ✨ Features

🚀 Easy integration with the Zoom Meeting SDK  
🔄 Initialize SDK using a JWT token  
🎯 Join meetings directly within your app (no Zoom app required)  
📱 Android & iOS platform support  
🔊 Full audio and video meeting experience  
🔐 Secure authentication flow via JWT

## 📦 Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_zoom_meeting_wrapper: ^0.0.2
```

---

## ⚙️ Mandatory Zoom SDK Setup

### 🤖 Android Setup

1. Add the dependency and run `flutter pub get`.
2. Download the Zoom SDK ZIP from the following link:  
   👉 [Zoom SDK Download](https://drive.google.com/file/d/1aKhrS5JCVSxvQkfdXH0N1h45Lk2gt6P9/view?usp=sharing)
3. Extract the ZIP file after downloading.
4. Copy the `libs` folder and paste it inside your Flutter pub-cache directory at:

   ```
   ~/.pub-cache/hosted/pub.dev/flutter_zoom_meeting_wrapper-0.0.2/android/
   ```

   > 🔁 Replace `0.0.2` with the version you’re using, if different.

5. Or run the following command to open the folder directly:
   ```bash
   open ~/.pub-cache/hosted/pub.dev/flutter_zoom_meeting_wrapper-0.0.2/android
   ```

> ⚠️ **Important:** The `libs` folder **must** be placed in the correct location for the plugin to function properly.

---

### 🍎 iOS Setup

The iOS integration requires placing the Zoom Meeting SDK frameworks into the plugin’s `ios/Frameworks/` directory inside the Flutter pub-cache. Follow these steps:

#### Step 1 — Download the Zoom iOS Meeting SDK

You can download the iOS SDK using either option below:

**Option A — Direct Download (Google Drive)**

👉 [Download iOS SDK from Google Drive](https://drive.google.com/file/d/1RxelKVkzyC_3ojn_yho07NiHYrOT7oUv/view?usp=sharing)

Extract the ZIP file after downloading.

**Option B — Zoom Marketplace**

1. Go to [https://marketplace.zoom.us/](https://marketplace.zoom.us/) and sign in.
2. Navigate to your app’s credentials page.
3. Download the **iOS Meeting SDK** ZIP package.
4. Extract the ZIP file.

#### Step 2 — Copy frameworks into the plugin

Open the pub-cache directory for the plugin’s iOS folder:

```bash
open ~/.pub-cache/hosted/pub.dev/flutter_zoom_meeting_wrapper-0.0.2/ios/Frameworks
```

> 🔁 Replace `0.0.2` with the version you’re using, if different.

Copy **all** of the following items from the extracted Zoom SDK into the `Frameworks/` folder:

| File / Folder                      | Description                         |
| ---------------------------------- | ----------------------------------- |
| `MobileRTC.xcframework`            | Core Zoom Meeting SDK               |
| `MobileRTCResources.bundle`        | UI resources (required at runtime)  |
| `MobileRTCScreenShare.xcframework` | Screen sharing support              |
| `zoomcml.xcframework`              | Zoom companion framework (required) |

After copying, the folder should look like:

```
ios/Frameworks/
├── MobileRTC.xcframework
├── MobileRTCResources.bundle
├── MobileRTCScreenShare.xcframework
└── zoomcml.xcframework
```

> ⚠️ **Important:** `zoomcml.xcframework` is required. If it is missing, `pod install` will fail with an error.

#### Step 3 — Configure minimum iOS version

In your app’s `ios/Podfile`, make sure the platform is set to **iOS 15.0** or higher:

```ruby
platform :ios, ‘15.0’
```

#### Step 4 — Exclude unsupported simulator architectures

The Zoom SDK frameworks include `arm64` simulator slices only (no `x86_64`). Add the following to your `ios/Podfile`’s `post_install` block to prevent build errors on Intel Mac simulators:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end

  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.user_project.native_targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings[‘EXCLUDED_ARCHS[sdk=iphonesimulator*]’] = ‘$(inherited) i386 x86_64’
        config.build_settings[‘SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD’] = ‘NO’
      end
    end
    aggregate_target.user_project.save
  end
end
```

#### Step 5 — Install pods

Run the following from your project’s `ios/` directory:

```bash
cd ios && pod install
```

#### Step 6 — Add required permissions

Add the following keys to your app’s `ios/Runner/Info.plist` so the system grants Zoom the access it needs:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video meetings.</string>

<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for audio in meetings.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required to share images in meetings.</string>
```

#### Step 7 — Build and run on a device

```bash
flutter run
```

> ⚠️ **Note:** The Zoom SDK simulator frameworks are `arm64`-only. Testing on a physical iPhone or iPad is recommended. Running on an Intel-based Mac simulator may not work even with the architecture exclusions above.

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

<img src="https://raw.githubusercontent.com/DevCodeSpace/flutter_zoom_meeting_wrapper/refs/heads/main/assets/contributors.png" width="230" alt="Zoom Meeting Wrapper contributors" />
