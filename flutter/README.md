# Flutter Google Maps App

A basic Flutter app with a Google Maps widget.

## Prerequisites

- Flutter SDK (3.0.0+)
- Android Studio / Xcode for mobile builds
- Google Maps API keys for Android and iOS

## Setup

### 1. Install Flutter dependencies

```powershell
cd flutter
flutter pub get
```

### 2. Configure Google Maps API keys

#### Android
Edit `android/app/src/main/AndroidManifest.xml` and replace `YOUR_ANDROID_API_KEY` with your actual key:

```xml
<meta-data android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_ANDROID_API_KEY"/>
```

#### iOS
Edit `ios/Runner/Info.plist` and replace `YOUR_IOS_API_KEY`:

```xml
<key>GMSApiKey</key>
<string>YOUR_IOS_API_KEY</string>
```

### 3. Get API keys

- Visit [Google Cloud Console](https://console.cloud.google.com/)
- Enable the **Maps SDK for Android** and **Maps SDK for iOS**
- Create API keys restricted to your app bundle/package ID

## Run

```powershell
# Check connected devices
flutter devices

# Run on connected device or emulator
flutter run

# Run on specific device
flutter run -d <device_id>
```

## Build

```powershell
# Android APK
flutter build apk

# iOS (requires macOS)
flutter build ios
```

## Project Structure

- `lib/main.dart` — Main app entry with a single page containing a Google Map
- `pubspec.yaml` — Dependencies (google_maps_flutter)
- `android/` — Android-specific config and manifest
- `ios/` — iOS-specific config and Info.plist

## Map customization

Edit `lib/main.dart` to change the initial camera position:

```dart
final LatLng _center = const LatLng(51.5074, -0.1278); // London
```

Adjust zoom level in `initialCameraPosition`:

```dart
CameraPosition(
  target: _center,
  zoom: 10.0,
),
```

## Notes

- The app uses `google_maps_flutter` package
- Minimum Android SDK: 21 (defined by Flutter defaults)
- iOS deployment target: 12.0 (defined by Flutter defaults)
- Location permissions are declared but not requested at runtime; add permission handling if needed

## Troubleshooting

- **Map not showing on Android**: Ensure you've added the correct API key and enabled Maps SDK for Android in Google Cloud.
- **Map not showing on iOS**: Check that the API key is set in Info.plist and Maps SDK for iOS is enabled.
- **Build errors**: Run `flutter clean && flutter pub get` and try again.

## Additional Dependancies
- intl (date formatting)
- calendar_date_picker2 (more customisable calendar)
- dio (handle network requests)
- custom_info_window (info window for Google Maps)