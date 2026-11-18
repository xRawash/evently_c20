import 'package:evently_app_abbas/data_sources/contracts/auth_data_source.dart';
import 'package:evently_app_abbas/firebase_services/firebase_services.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirestoreDataSourceImpl implements AuthDataSource {
  @override
  Future<void> addUserToFireStore(UserModel user) async {
    return FirebaseServices.addUserToFireStore(user);
  }

  @override
  Future<UserModel?> getCurrentUser(String uid) async {
    return FirebaseServices.getCurrentUser(uid);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return FirebaseServices.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return FirebaseServices.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    return FirebaseServices.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return FirebaseServices.signOut();
  }
}
