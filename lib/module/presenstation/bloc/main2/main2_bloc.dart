import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'main2_event.dart';
part 'main2_state.dart';

@injectable
class Main2Bloc extends BaseCubit<Main2State> {
  ContentUseCase contentUseCase;

  @factoryMethod
  Main2Bloc(this.contentUseCase) : super(InitialMain2State());

  @override
  void closeStream() {
    // TODO: implement closeStream
  }

  @override
  void initEventState() {
    // TODO: implement initEventState
  }

  Future<void> loginGoogle() async {
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
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      // setState(() {
      //   error = '${e.message}';
      // });
    } finally {
      // setIsLoading();
    }
  }

  void loginFacebook() {}
}
