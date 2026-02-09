# Firebase Setup Guide for AstroConnect

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add Project"
3. Enter project name: `astroconnect-app` (or your preferred name)
4. Disable Google Analytics for now (optional)
5. Click "Create Project"

## Step 2: Add Android App

1. Click the Android icon to add an Android app
2. Register app with package name: `com.ramansubedi.astro_social_app`
3. (Optional) Add nickname: AstroConnect
4. (Optional) Add SHA-1 certificate (for Google Sign-In later)
5. Click "Register App"
6. Download `google-services.json`
7. Move the file to: `android/app/google-services.json`
8. Click "Next" and "Continue to Console"

## Step 3: Add iOS App (Optional)

1. Click the iOS icon to add an iOS app
2. Register app with bundle ID: `com.ramansubedi.astroSocialApp`
3. Download `GoogleService-Info.plist`
4. Move the file to: `ios/Runner/GoogleService-Info.plist`
5. Click "Next" and "Continue to Console"

## Step 4: Enable Authentication

1. Go to "Authentication" in the left sidebar
2. Click "Get Started"
3. Enable "Email/Password" provider
4. Save

## Step 5: Set Up Firestore Database

1. Go to "Firestore Database" in the left sidebar
2. Click "Create Database"
3. Choose "Start in test mode" (for development)
4. Select a location close to your users (e.g., `asia-south1` for India)
5. Click "Enable"

## Step 6: Set Up Firebase Storage

1. Go to "Storage" in the left sidebar
2. Click "Get Started"
3. Choose "Start in test mode"
4. Select the same location as Firestore
5. Click "Done"

## Step 7: Update Firebase Config in Code

Open `lib/main.dart` and update the Firebase options with your actual configuration:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_ACTUAL_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID",
  ),
);
```

You can find these values in your Firebase Console:
- Project Settings → General → Your apps → SDK setup and configuration

## Step 8: Firestore Security Rules (Development)

Go to Firestore Database → Rules and use these rules for development:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Note**: Update these rules for production with proper security restrictions.

## Step 9: Storage Security Rules (Development)

Go to Storage → Rules and use these rules for development:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Step 10: Run the App

```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

## Troubleshooting

### Error: "Firebase App is not initialized"
- Make sure `google-services.json` is in the correct location
- Run `flutter clean` and rebuild

### Error: "SHA-1 certificate fingerprint"
- Get your SHA-1: `cd android && ./gradlew signingReport`
- Add it to Firebase Console → Project Settings → Your apps → Android app

### Error: "Missing google_app_id"
- Ensure `google-services.json` is properly placed
- Ensure the package name matches exactly

## Next Steps

After Firebase setup is complete, you can:
1. Register test users
2. Create kundalis
3. Test Chinaa matching
4. Develop social features

For production deployment, remember to:
- Set up proper security rules
- Configure Firebase App Check
- Set up Firebase Analytics
- Configure billing alerts
