import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/core/sources/validator.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../firebase_services/firebase_services.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;

  late TextEditingController emailController;

  late TextEditingController passwordController;

  late TextEditingController passwordConfirmationController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    ImageAssets.eventlyLogo,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    AppLocalizations.of(context)!.createYourAccount,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    validator: Validator.validateName,
                    controller: nameController,
                    hintText: AppLocalizations.of(context)!.enterYourName,
                    prefixIcon: Icon(Icons.person),
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    validator: Validator.validateEmail,
                    controller: emailController,
                    hintText: AppLocalizations.of(context)!.enterYourEmail,
                    prefixIcon: Icon(Icons.email),
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    validator: Validator.validatePassword,
                    controller: passwordController,
                    isObscured: true,
                    hintText: AppLocalizations.of(context)!.enterYourPassword,
                    prefixIcon: Icon(Icons.lock),
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    validator: (input) {
                      if (input != passwordController.text) {
                        return AppLocalizations.of(
                          context,
                        )!.passwordDoesNotMatch;
                      }
                      return null;
                    },
                    controller: passwordConfirmationController,
                    hintText: AppLocalizations.of(
                      context,
                    )!.enterYourPasswordConfirmation,
                    isObscured: true,
                    prefixIcon: Icon(Icons.lock),
                  ),

                  SizedBox(height: 52),
                  CustomElevatedButton(
                    title: AppLocalizations.of(context)!.signUp,
                    onPress: _createAccount,
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.alreadyHaveAnAccount,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      CustomTextButton(
                        text: AppLocalizations.of(context)!.login,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.login,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  OutlinedButton(
                    onPressed: () {
                      _signUpWithGoogle();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorsManager.darkBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ImageAssets.googleDark),
                        SizedBox(width: 24),
                        Text(
                          "SignUp With Google",
                          style: TextStyle(color: ColorsManager.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createAccount() async {
    if (_formKey.currentState!.validate() == false) return;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
      UserModel user = UserModel(name: nameController.text, id: userCredential.user!.uid, email: emailController.text);
      await FirebaseServices.addUserToFireStore(user);
      Navigator.pushReplacementNamed(context, RoutesManager.login);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          _showToast('Email already used');
          break;
        case 'weak-password':
          _showToast('Password is too weak');
          break;
        case 'invalid-email':
          _showToast('Invalid email address');
          break;
        case 'network-request-failed':
          _showToast('Network error. Check your connection.');
          break;
        default:
          _showToast('Sign up failed. Please try again.');
      }
    } on FirebaseException {
      _showToast('Could not save your profile. Please try again.');
    } catch (e) {
      _showToast('Something went wrong. Please try again.');
    }
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  Future<UserCredential?> _signUpWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '249340315739-m3ff47n74k3da51lumklbin7vgeg5bjc.apps.googleusercontent.com',
      );
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      UserModel user = UserModel(name: googleUser.displayName!, id: userCredential.user!.uid, email: googleUser.email);
      await FirebaseServices.addUserToFireStore(user);
      UserModel.loggedInUser = user;
      if (!mounted) return userCredential;
      bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
      if(isNewUser) {
        _showToast('Account created successfully.');
        Navigator.pushReplacementNamed(context, RoutesManager.login);
        return userCredential;
      }else {
        _showToast('Welcome back!');
        Navigator.pushReplacementNamed(context, RoutesManager.mainLayout);
        return userCredential;
      }

    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          _showToast('Sign-up cancelled');
          break;
        default:
          _showToast('Google sign-up failed. Please try again.');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          _showToast(
            'An account already exists with a different sign-in method.',
          );
          break;
        case 'invalid-credential':
          _showToast('The Google credential is invalid or expired.');
          break;
        case 'user-disabled':
          _showToast('This account has been disabled.');
          break;
        case 'network-request-failed':
          _showToast('Network error. Check your connection.');
          break;
        default:
          _showToast('Sign-in failed. Please try again.');
      }
      return null;
    } catch (e) {
      _showToast('Something went wrong. Please try again.');
      return null;
    }
  }
}
