import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getCurrentUser() async {

    // get current user
    final firebaseUser = firebaseAuth.currentUser;

    // no user logged in
    if (firebaseUser == null) {
      return null;
    }

    // fetch user document
    DocumentSnapshot userDoc = await firebaseFirestore.collection('users').doc(firebaseUser.uid).get();

    // check if userDoc exists
    if (userDoc.exists) {
      return null;
    }

    // user logged in
    return AppUser(email: firebaseUser.email!, name: userDoc['name'], uid: firebaseUser.uid);
  }

  @override
  Future<AppUser?> loginWithEmailAndPassword(String email, String password) async {
    try {
      // attempt login
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // fetch user document
      DocumentSnapshot userDoc = await firebaseFirestore.collection('users').doc(userCredential.user!.uid).get();

      // create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc['name'],
      );

      // return user
      return user;
    } catch (e) {
      throw Exception('Login failed $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      // attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // save user data in Firestore
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      // return user
      return user;
    } catch (e) {
      throw Exception('Login failed $e');
    }
  }
}
