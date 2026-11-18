import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/core/sources/validator.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);

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
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    validator: Validator.validateEmail,
                    controller: emailController,
                    hintText: AppLocalizations.of(context)!.enterYourEmail,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    validator: Validator.validatePassword,
                    controller: passwordController,
                    isObscured: true,
                    hintText: AppLocalizations.of(context)!.enterYourPassword,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 8),
                  CustomTextButton(
                    text: AppLocalizations.of(context)!.forgetPassword,
                    textAlign: TextAlign.end,
                    onTap: () {},
                  ),
                  const SizedBox(height: 52),
                  authViewModel.status == AuthStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomElevatedButton(
                          title: AppLocalizations.of(context)!.login,
                          onPress: () => login(authViewModel),
                        ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => _loginWithGoogle(authViewModel),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ColorsManager.darkBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ImageAssets.googleDark),
                        const SizedBox(width: 24),
                        const Text(
                          "Login With Google",
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

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  void login(AuthViewModel authViewModel) async {
    if (formKey.currentState!.validate() == false) return;
    bool success = await authViewModel.login(
      emailController.text.trim(),
      passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      _showToast('Login successful.');
      Navigator.pushReplacementNamed(context, RoutesManager.mainLayout);
    } else if (authViewModel.errorMessage != null) {
      _showToast(authViewModel.errorMessage!);
    }
  }

  void _loginWithGoogle(AuthViewModel authViewModel) async {
    bool success = await authViewModel.loginWithGoogle();
    if (!mounted) return;
    if (success) {
      _showToast('Logged in successfully');
      Navigator.pushReplacementNamed(context, RoutesManager.mainLayout);
    } else if (authViewModel.errorMessage != null) {
      _showToast(authViewModel.errorMessage!);
    }
  }
}
