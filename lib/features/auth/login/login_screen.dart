import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/core/sources/validator.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/sources/assets_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    ImageAssets.eventlyLogo,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    AppLocalizations.of(context)!.loginToYourAccount,
                    style: Theme.of(context).textTheme.headlineLarge,
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
                  SizedBox(height: 8),
                  CustomTextButton(
                    text: AppLocalizations.of(context)!.forgetPassword,
                    textAlign: TextAlign.end,
                    onTap: () {},
                  ),
                  SizedBox(height: 52),
                  CustomElevatedButton(
                    title: AppLocalizations.of(context)!.login,
                    onPress: login,
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
                        text: AppLocalizations.of(context)!.signUp,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.register,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {
                      _loginWithGoogle();
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
                        Text("Login With Google", style: TextStyle(color: ColorsManager.blue),),
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

  void login() async {

    if (formKey.currentState!.validate() == false) return;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
      Navigator.pushReplacementNamed(context, RoutesManager.mainLayout);
    } on FirebaseAuthException catch (e) {

      if (e.code == 'invalid-credential') {
        Fluttertoast.showToast(
          msg: "No user found for that email.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16,
        );
      } else if (e.code == 'invalid-credential') {
        Fluttertoast.showToast(
          msg: "Wrong email or password.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    }
  }

  Future<UserCredential?> _loginWithGoogle() async {
    try{
      await GoogleSignIn.instance.initialize(
          serverClientId: '249340315739-m3ff47n74k3da51lumklbin7vgeg5bjc.apps.googleusercontent.com'
      );

      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();


      final GoogleSignInAuthentication googleAuth = googleUser.authentication;


      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      Navigator.pushReplacementNamed(context, RoutesManager.mainLayout);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          debugPrint('Sign-in cancelled by user');
          break;
        default:
          debugPrint('GoogleSignInException: ${e.code} - ${e.description}');
      }
      return null;

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          debugPrint('Account exists with a different sign-in method.');
          break;
        case 'invalid-credential':
          debugPrint('The Google credential is malformed or expired.');
          break;
        case 'user-disabled':
          debugPrint('This user account has been disabled.');
          break;
        case 'network-request-failed':
          debugPrint('Network error — check your connection.');
          break;
        default:
          debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      }
      return null;

    } catch (e) {
      debugPrint('Unexpected error during Google sign-in: $e');
      return null;
    }
  }
}
