import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/core/sources/validator.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController ;

  late TextEditingController emailController ;

  late TextEditingController passwordController ;

  late TextEditingController passwordConfirmationController ;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(ImageAssets.eventlyLogo, color: Theme.of(context).primaryColor,),
                Text(
                  "Create your account",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: Validator.validateName,
                  controller: nameController,
                  hintText: "Enter ur name",
                  prefixIcon: Icon(Icons.person),
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
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: (input) {
                    if (input != passwordController.text) {
                      return "Password dose not match";
                    }
                    return null;
                  },
                  controller: passwordConfirmationController,
                  hintText: "Enter ur password confirmation",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),

                SizedBox(height: 52),
                CustomElevatedButton(title: "Sign-Up", onPress: _createAccount),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    CustomTextButton(
                      text: "Login",
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          RoutesManager.login,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void _createAccount() {
    if (_formKey.currentState!.validate() == false) return;
  }
}
