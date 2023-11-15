import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign In
  signInWithGoogle() async {
    // start interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //get auth details from google
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // create a new credential
    final gCredential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    // sign in with credential
    return await FirebaseAuth.instance.signInWithCredential(gCredential);
  }
}
