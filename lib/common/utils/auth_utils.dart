import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthUtils {
  static final AuthUtils instance = AuthUtils._getInstance();

  AuthUtils._getInstance();

  Future<UserCredential> loginGoogle() async {
    Completer<UserCredential> completer = Completer();
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;
      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Once signed in, return the UserCredential
        var userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        completer.complete(userCredential);
      }
    } on FirebaseAuthException catch (e) {
      completer.completeError(e);
      print("error$e");
    }
    return completer.future;
  }

  Future<UserCredential> loginFacebook() async {
    Completer<UserCredential> completer = Completer();
    try {
      LoginResult loginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      // Once signed in, return the UserCredential
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      completer.complete(userCredential);
    } on FirebaseAuthException catch (e) {
      completer.completeError(e);
      print("error$e");
    }
    return completer.future;
  }

  Future<UserCredential> loginApple() {
    return Future.value();
  }
}
