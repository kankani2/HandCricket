# handcricket

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Configuration

To be able to run flutter, you will require some secret files that have not been committed.

- `lib/config.dart` - Contains `devMode` boolean which tells whether we are running the app against
server running locally or prod app engine server. `hostName` string which is basically the
`PROJECT-ID.appspot.com`.
- `android/app/google-services.json` - Required for Firebase integration.
- `ios/Runner/GoogleService-Info.plist` - Required for Firebase integration.
