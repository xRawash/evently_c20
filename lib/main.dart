import 'package:evently_app_abbas/config/theme/theme_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/features/auth/login/login_screen.dart';
import 'package:evently_app_abbas/features/auth/register/register_screen.dart';
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

  runApp(
    ChangeNotifierProvider(
      create: (context) => ConfigProvider(),
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
      initialRoute: isFinishedOnBoarding ? RoutesManager.register : RoutesManager.onboarding,
      onGenerateRoute: RoutesManager.getRoute,
      theme: ThemeManager.light,
      darkTheme: ThemeManager.dark,
      themeMode: configProvider.currentTheme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ar')],
      locale: Locale(configProvider.currentLang),
    );
  }
}
