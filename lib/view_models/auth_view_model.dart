import 'package:evently_app_abbas/models/user_model.dart';
import 'package:evently_app_abbas/repositories/contracts/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus { initial, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  AuthStatus status = AuthStatus.initial;
  String? errorMessage;
  UserModel? currentUser = UserModel.loggedInUser;

  Future<bool> login(String email, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      UserCredential userCredential =
          await _authRepository.signInWithEmailAndPassword(email, password);
      UserModel? user =
          await _authRepository.getCurrentUser(userCredential.user!.uid);
      if (user != null) {
        currentUser = user;
        UserModel.loggedInUser = user;
        status = AuthStatus.success;
        notifyListeners();
        return true;
      } else {
        status = AuthStatus.error;
        errorMessage = 'User record not found.';
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      status = AuthStatus.error;
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'Wrong email or password.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Check your connection.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }
      notifyListeners();
      return false;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      UserCredential userCredential =
          await _authRepository.createUserWithEmailAndPassword(email, password);
      UserModel user = UserModel(
        name: name,
        id: userCredential.user!.uid,
        email: email,
      );
      await _authRepository.addUserToFireStore(user);
      currentUser = user;
      UserModel.loggedInUser = user;
      status = AuthStatus.success;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      status = AuthStatus.error;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email already in use';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Check your connection.';
          break;
        default:
          errorMessage = 'Sign up failed. Please try again.';
      }
      notifyListeners();
      return false;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      UserCredential? credential = await _authRepository.signInWithGoogle();
      if (credential != null) {
        currentUser = UserModel.loggedInUser;
        status = AuthStatus.success;
        notifyListeners();
        return true;
      } else {
        status = AuthStatus.initial;
        notifyListeners();
        return false;
      }
    } on GoogleSignInException catch (e) {
      status = AuthStatus.error;
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          errorMessage = 'Sign-in cancelled';
          break;
        default:
          errorMessage = 'Google sign-in failed. Please try again.';
      }
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      status = AuthStatus.error;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'An account already exists with a different sign-in method.';
          break;
        case 'invalid-credential':
          errorMessage = 'The Google credential is invalid or expired.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Check your connection.';
          break;
        default:
          errorMessage = 'Sign-in failed. Please try again.';
      }
      notifyListeners();
      return false;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    currentUser = null;
    status = AuthStatus.initial;
    notifyListeners();
  }
}
