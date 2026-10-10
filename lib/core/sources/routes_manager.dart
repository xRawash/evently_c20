import 'package:evently_app_abbas/features/auth/login/login_screen.dart';
import 'package:evently_app_abbas/features/auth/register/register_screen.dart';
import 'package:evently_app_abbas/features/create_event/create_event_screen.dart';
import 'package:evently_app_abbas/features/event_details/event_details.dart';
import 'package:evently_app_abbas/features/main_layout/main_layout_screen.dart';
import 'package:evently_app_abbas/features/onboarding/onboardingScreen.dart';
import 'package:flutter/cupertino.dart';

import '../../features/update_event/update_event.dart';

class RoutesManager{
  static const String register = '/register';
  static const String login = '/login';
  static const String mainLayout = '/mainLayout';
  static const String createEvent = '/createEvent';
  static const String onboarding = '/onboarding';
  static const String eventDetails = '/eventDetails';
  static const String updateEvent = '/updateEvent';

  static Route? getRoute(RouteSettings settings){
    switch(settings.name){
      case register:{
        return CupertinoPageRoute(builder: (context)=>RegisterScreen());
      }
      case login:{
        return CupertinoPageRoute(builder: (context)=>LoginScreen());
      }case mainLayout: {
        return CupertinoPageRoute(builder: (context)=>MainLayoutScreen());
      }
      case createEvent: {
        return CupertinoPageRoute(builder: (context)=>CreateEventScreen());
      }case onboarding : {
        return CupertinoPageRoute(builder: (context)=>OnboardingScreen());
      }case eventDetails : {
        return CupertinoPageRoute(builder: (context)=>EventDetails(), settings: settings);
      }
      case updateEvent : {
        return CupertinoPageRoute(builder: (context)=>UpdateEvent(), settings: settings);
      }
      default:{
        return null;
    }

    }
  }
}