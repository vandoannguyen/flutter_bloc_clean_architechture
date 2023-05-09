# baese_flutter_bloc

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
### Gennerrate file in project
flutter packages pub run build_runner build --delete-conflicting-outputs

## Upload dSYMs
./ios/Pods/FirebaseCrashlytics/upload-symbols -gsp ios/GoogleService-Info.plist -p ios ~
/Desktop/dsym/v1.0.8_dSYMs

## debug with flavor
dev  flutter run --flavor dev -t lib/main_dev.dart
product  flutter run --flavor prod -t lib/main.dart
uat  flutter run --flavor uat -t lib/main_uat.dart

## build apk with flavor
dev  flutter build apk --flavor dev -t lib/main_dev.dart
product  flutter build apk --flavor prod -t lib/main.dart
uat  flutter build apk --flavor uat -t lib/main_uat.dart

## release with flavor
dev  flutter build appbundle --flavor dev -t lib/main_dev.dart
product  flutter build appbundle --flavor prod -t lib/main.dart
uat  flutter build appbundle --flavor uat -t lib/main_uat.dart