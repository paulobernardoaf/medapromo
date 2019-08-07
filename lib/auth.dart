import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final Firestore _db = Firestore.instance;

  AuthService() {
    user = Observable(_firebaseAuth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }  


  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signInWithCredentials(String email, String password) async {

    FirebaseUser user;

    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then( (val) async {
        user = await _firebaseAuth.currentUser();
      }
    );

    return user;

  }

  Future<FirebaseUser> signUp(String email, String password, String name) async {

    UserUpdateInfo userInfo = UserUpdateInfo();
    userInfo.displayName = name;

    FirebaseUser updatedUser;

    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((val) async {
      
      FirebaseUser user = await _firebaseAuth.currentUser();
      
      await user.updateProfile(userInfo);
      await user.reload();

      updatedUser = await _firebaseAuth.currentUser();
      
    });

    return updatedUser;
     
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }


}

final AuthService authService = AuthService(); 
