import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<String> signInWithGoogle();
  Stream<String> get onAuthStateChanged;
  Future<void> signOut();
  String uid();
}

class Auth implements BaseAuth {
  String userId;

  @override
  String uid() {
    return userId;
  }

   @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }

  @override
  Stream<String> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged.map((
        FirebaseUser user) => userId = user?.uid); //user? is a shorthand notation to return userid only if it is not null
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }

  @override
  Future<String> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user?.uid;
  }

  @override
  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user?.uid;
  }
}