import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/core/sources/validator.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:flutter/material.dart';

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
    // TODO: implement initState
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(ImageAssets.eventlyLogo, color: Theme.of(context).primaryColor),
                Text(
                  "Login to your account",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: Validator.validateEmail,
                  controller: emailController,
                  hintText: "Enter ur email",
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: Validator.validatePassword,
                  controller: passwordController,
                  hintText: "Enter ur password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),
                SizedBox(height: 8,),
                CustomTextButton(text: "Forget Password? ", textAlign: TextAlign.end,onTap: () {}),
                SizedBox(height: 52),
                CustomElevatedButton(title: "Login", onPress: login),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    CustomTextButton(text: "Sign-Up", onTap: () {
                      Navigator.pushReplacementNamed(context, RoutesManager.register);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void login(){
    if(formKey.currentState!.validate() == false) return;
  }

}
