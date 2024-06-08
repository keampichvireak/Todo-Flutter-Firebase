import 'package:authflutter/models/usermodel/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> saveUserDataToFirestore(User user) async {
    UserModal userModel = UserModal(
      uid: user.uid,
      email: user.email!,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(userModel.toJson());
  }

  signInWithGoogle() async {
    //begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    //Get the signed-in user
    User? user = userCredential.user;
    if (user != null) {
      //Save user data to Firebase
      await saveUserDataToFirestore(user);
    }
    // finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
