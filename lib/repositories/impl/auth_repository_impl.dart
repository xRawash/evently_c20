import 'package:evently_app_abbas/data_sources/contracts/auth_data_source.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:evently_app_abbas/repositories/contracts/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl({required AuthDataSource authDataSource})
      : _authDataSource = authDataSource;

  @override
  Future<void> addUserToFireStore(UserModel user) {
    return _authDataSource.addUserToFireStore(user);
  }

  @override
  Future<UserModel?> getCurrentUser(String uid) {
    return _authDataSource.getCurrentUser(uid);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return _authDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return _authDataSource.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential?> signInWithGoogle() {
    return _authDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _authDataSource.signOut();
  }
}
