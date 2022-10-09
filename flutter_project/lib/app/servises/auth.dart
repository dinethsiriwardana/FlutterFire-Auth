import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time_tracker_flutter_course/services/print_c.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInAnonymously();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFaceBook();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailandPassword(String email, String password);
  Future<void> signOut();
  Future<void> deleteOut();
}

class Auth implements AuthBase {
  printInConsole(title, msg) {
    PrintInConsole printc = new PrintInConsole();
    printc.printInCS(title, msg);
  }

  final _firebaseAuth = FirebaseAuth.instance;

  @override
  //Stream Builder
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
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
  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    printInConsole("Google Sign In :- ", "${googleSignIn}");

    final googleUser = await googleSignIn.signIn();
    //this is the code that will let the user signing with there google accounts

    printInConsole("google User :- ", "${googleUser}");

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication; //get the acc token
      printInConsole("Google authentication :- ", "${googleAuth.idToken}");
      printInConsole("Google authentication :- ", "${googleAuth.accessToken}");

      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        printInConsole("user Credential :- ", "${userCredential.user}");

        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User?> signInWithFaceBook() async {
    final fb = FacebookLogin();

    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredential.user;

      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FB_LOGIN_FAILED',
          message: response.error?.developerMessage,
        );
      default:
        throw UnimplementedError();
    }

    // printInConsole("google User :- ", "${googleUser}");
  }

  @override
  Future<void> deleteOut() async {
    await currentUser!.delete(); //FirebaseAuth.instance.currentUser.delete
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    await _firebaseAuth.signOut();
  }
}
