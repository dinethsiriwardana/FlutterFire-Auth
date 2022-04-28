import 'package:firebase_auth/firebase_auth.dart';

//You can call classes using the provider -> final auth = Provider.of<AuthBase>(context, listen: false);

abstract class AuthBase {
  Stream<User?> authStateChanges();
  Future<void> signOut();
  Future<void> deleteacc();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailandPassword(String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  //Stream Builder
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  // currentUser = FirebaseAuth.instance.currentUser;
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  // SignIn using Email
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailandPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteacc() async {
    await currentUser!.delete();
  }
}
