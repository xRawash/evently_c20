import 'package:evently_app_abbas/config/theme/theme_manager.dart';
import 'package:evently_app_abbas/core/di/dependency_injection.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:evently_app_abbas/view_models/auth_view_model.dart';
import 'package:evently_app_abbas/view_models/event_form_view_model.dart';
import 'package:evently_app_abbas/view_models/fav_view_model.dart';
import 'package:evently_app_abbas/view_models/home_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'prefs_manager/prefs_manager.dart';
import 'providers/config_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PrefsManager.init();

  final authRepo = DependencyInjection.provideAuthRepository();
  final eventRepo = DependencyInjection.provideEventRepository();

  if (FirebaseAuth.instance.currentUser != null) {
    try {
      UserModel.loggedInUser = await authRepo
          .getCurrentUser(FirebaseAuth.instance.currentUser!.uid);
    } catch (_) {}
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ChangeNotifierProvider(
            create: (_) => AuthViewModel(authRepository: authRepo)),
        ChangeNotifierProvider(
            create: (_) => HomeViewModel(eventRepository: eventRepo)),
        ChangeNotifierProvider(
            create: (_) => FavViewModel(eventRepository: eventRepo)),
        ChangeNotifierProvider(
            create: (_) => EventFormViewModel(eventRepository: eventRepo)),
      ],
      child: const Evently(),
    ),
  );
}

class Evently extends StatelessWidget {
  const Evently({super.key});

  @override
  Widget build(BuildContext context) {
    final isFinishedOnBoarding = PrefsManager.getFinishedOnBoarding() ?? false;
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isFinishedOnBoarding
          ? (FirebaseAuth.instance.currentUser != null
              ? RoutesManager.mainLayout
              : RoutesManager.register)
          : RoutesManager.onboarding,
      onGenerateRoute: RoutesManager.getRoute,
      theme: ThemeManager.light,
      darkTheme: ThemeManager.dark,
      themeMode: configProvider.currentTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: Locale(configProvider.currentLang),
    );
  }
}
