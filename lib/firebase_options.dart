import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions currentPlatform() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android();
      case TargetPlatform.iOS:
        return ios();
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions android() {
    return FirebaseOptions(
      apiKey: dotenv.get("android.firebase.apiKey"),
      appId: dotenv.get("android.firebase.appId"),
      messagingSenderId: dotenv.get("android.firebase.messagingSenderId"),
      projectId: dotenv.get("android.firebase.projectId"),
    );
  }

  static FirebaseOptions ios() {
    return FirebaseOptions(
      apiKey: dotenv.get("ios.firebase.apiKey"),
      appId: dotenv.get("ios.firebase.appId"),
      messagingSenderId: dotenv.get("ios.firebase.messagingSenderId"),
      projectId: dotenv.get("ios.firebase.projectId"),
    );
  }
}
