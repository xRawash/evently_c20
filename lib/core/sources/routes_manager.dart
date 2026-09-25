import 'package:evently_app_abbas/features/auth/login/login_screen.dart';
import 'package:evently_app_abbas/features/auth/register/register_screen.dart';
import 'package:evently_app_abbas/features/create_event/create_event_screen.dart';
import 'package:evently_app_abbas/features/main_layout/main_layout_screen.dart';
import 'package:flutter/cupertino.dart';

class RoutesManager{
  static const String register = '/register';
  static const String login = '/login';
  static const String mainLayout = '/mainLayout';
  static const String createEvent = '/createEvent';

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
      }

    }
  }
}