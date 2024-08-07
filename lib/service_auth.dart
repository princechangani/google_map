import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      // Begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        // The user canceled the sign-in
        print('Sign-in process was canceled by the user.');
        return null;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Finally, let's sign in
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Print the email ID
      print('Signed in as: ${userCredential.user?.email}');

      return userCredential.user;
    } catch (e) {
      print('Sign-in failed: $e');
      return null;
    }
  }
}
