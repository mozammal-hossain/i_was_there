# Google Login Implementation

## Overview

The app uses `google_sign_in: ^7.2.0` for Google authentication, primarily to enable Google Calendar sync. The auth logic lives in `lib/data/sync/google_auth_service_impl.dart` and uses `GoogleSignIn.instance` (singleton pattern from v7).

## Architecture

```
GoogleAuthService (interface)
  └── GoogleAuthServiceImpl (registered via @LazySingleton)
        └── GoogleSignIn.instance
              ├── authenticate(scopeHint: [calendarScope])
              ├── attemptLightweightAuthentication()
              └── signOut()
```

- **Sign-in** — calls `authenticate()` with the Calendar scope hint, triggering the full OAuth consent flow.
- **Cached sign-in** — calls `attemptLightweightAuthentication()` on app launch to restore a previous session silently.
- **Auth headers** — obtained from `GoogleSignInAccount.authorizationClient.authorizationHeaders()` for Calendar API requests.

## Android Setup

### Prerequisites

1. A Firebase project (or standalone GCP project) with an Android app registered using package name `com.iwasthere.app`.
2. The SHA-1 fingerprint of your signing key added to the Firebase/GCP Android app.

### Steps

1. **Enable Google Sign-In** in Firebase Console → Authentication → Sign-in method → Google.

2. **Ensure a Web OAuth client exists** in GCP Console → APIs & Credentials → OAuth 2.0 Client IDs. Firebase creates one automatically when you enable Google Sign-In. This is critical — the `google_sign_in` plugin reads the web client ID (`client_type: 3`) from `google-services.json`.

3. **Download `google-services.json`** from Firebase Console → Project Settings → General → Your apps → Android app.

4. **Place it at** `android/app/google-services.json`.

5. **Verify the file** contains a web OAuth client entry:

   ```json
   "oauth_client": [
     {
       "client_id": "<your-web-client-id>.apps.googleusercontent.com",
       "client_type": 3
     }
   ]
   ```

   If `client_type: 3` is missing, add a Web app to your Firebase project and re-download the file.

6. The Gradle plugin `com.google.gms.google-services` (v4.4.2) is already applied in `android/app/build.gradle.kts` and `android/settings.gradle.kts`. No changes needed.

### Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `serverClientId must be provided on Android` | `google-services.json` is missing or lacks a `client_type: 3` entry | Download a fresh `google-services.json` after ensuring a Web client exists in your project |
| `DEVELOPER_ERROR` | SHA-1 mismatch or wrong package name | Verify SHA-1 fingerprint and package name in Firebase Console |
| `sign_in_canceled` | User cancelled the consent screen, or OAuth consent screen not configured | Configure the OAuth consent screen in GCP Console |

## iOS Setup

On iOS, `google_sign_in` reads configuration from `ios/Runner/GoogleService-Info.plist` (also gitignored). Download it from Firebase Console → Project Settings → Your apps → iOS app and place it in `ios/Runner/`.

## Security Notes

- `google-services.json` and `GoogleService-Info.plist` are gitignored (see `.gitignore` lines 80–88) and must be added locally by each developer.
- No OAuth client IDs are hardcoded in the Dart source.
- The only requested scope is `https://www.googleapis.com/auth/calendar`.
