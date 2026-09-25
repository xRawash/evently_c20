import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/core/sources/validator.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
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
                  hintText: AppLocalizations.of(context)!.enterYourPassword,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  validator: (input) {
                    if (input != passwordController.text) {
                      return AppLocalizations.of(context)!.passwordDoesNotMatch;
                    }
                    return null;
                  },
                  controller: passwordConfirmationController,
                  hintText: AppLocalizations.of(context)!.enterYourPasswordConfirmation,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                ),

                SizedBox(height: 52),
                CustomElevatedButton(title: AppLocalizations.of(context)!.signUp, onPress: _createAccount),
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
