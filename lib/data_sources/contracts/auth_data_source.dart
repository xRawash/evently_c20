import 'package:evently_app_abbas/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<void> addUserToFireStore(UserModel user);
  Future<UserModel?> getCurrentUser(String uid);
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password);
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
}
