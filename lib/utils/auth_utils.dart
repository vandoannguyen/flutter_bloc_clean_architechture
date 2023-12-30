import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthUtils {
  static final AuthUtils instance = AuthUtils._getInstance();

  AuthUtils._getInstance();

  Future<AuthUtilsCredential> loginGoogle() async {
    Completer<AuthUtilsCredential> completer = Completer();
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      if (googleAuth != null) {
        completer.complete(
          AuthUtilsCredential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken),
        );
      } else {
        throw "googleAuth null";
      }
    } on Exception catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<AuthUtilsCredential> loginFacebook() async {
    Completer<AuthUtilsCredential> completer = Completer();
    try {
      LoginResult loginResult = await FacebookAuth.instance.login();
      completer.complete(
        AuthUtilsCredential(accessToken: loginResult.accessToken!.token),
      );
    } on Exception catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<AuthUtilsCredential> loginApple() async {
    Completer<AuthUtilsCredential> completer = Completer();
    final result = await TheAppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        completer.complete(
          AuthUtilsCredential(
            accessToken:
            String.fromCharCodes(appleIdCredential.authorizationCode!),
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          ),
        );
        break;
      case AuthorizationStatus.error:
        completer.completeError(result.error!);
        break;
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
    return completer.future;
  }

  Future<UserCredential> firebaseLoginGoogle() async {
    Completer<UserCredential> completer = Completer();
    try {
      var authUtilsCredential = await loginGoogle();
      final credential = GoogleAuthProvider.credential(
        accessToken: authUtilsCredential.accessToken,
        idToken: authUtilsCredential.idToken,
      );
      var userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      completer.complete(userCredential);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<UserCredential> firebaseLoginFacebook() async {
    Completer<UserCredential> completer = Completer();
    try {
      var authUtilsCredential = await loginFacebook();
      final credential =
      FacebookAuthProvider.credential(authUtilsCredential.accessToken!);
      var userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      completer.complete(userCredential);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<UserCredential> firebaseLoginApple() async {
    Completer<UserCredential> completer = Completer();
    try {
      var authUtilsCredential = await loginApple();
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: authUtilsCredential.idToken,
        accessToken: authUtilsCredential.accessToken,
      );
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      completer.complete(userCredential);
    } catch (err) {
      completer.completeError(err);
    }
    return completer.future;
  }
}

class AuthUtilsCredential {
  String? idToken;
  String? accessToken;

  AuthUtilsCredential({this.idToken, this.accessToken});
}
