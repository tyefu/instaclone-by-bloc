import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/screens/comments/comments_screen.dart';
import 'package:flutter_app_instaclone/screens/edit_profile/edit_profile_screen.dart';
import 'package:flutter_app_instaclone/screens/login/login_screen.dart';
import 'package:flutter_app_instaclone/screens/nav/nav_screen.dart';
import 'package:flutter_app_instaclone/screens/profile/profile_screen.dart';
import 'package:flutter_app_instaclone/screens/signup/signup_screen.dart';
import 'package:flutter_app_instaclone/screens/splash_screen.dart';

class CustomRouter{
  static Route onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(
          settings: RouteSettings(name: '/'),
            builder: (_)=> Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      default:
        return _errorRoute();
    }
  }
  static Route onGenerateNestedRoute(RouteSettings settings){
    print('Nested Route: ${settings.name}');
    switch(settings.name){
      case ProfileScreen.routeName:
        return ProfileScreen.route(args: settings.arguments);

      case EditProfileScreen.routeName:
        return EditProfileScreen.route(args: settings.arguments);

      case CommentsScreen.routeName:
        return CommentsScreen.route(args: settings.arguments);
      default:
        return _errorRoute();
    }
  }
  static Route _errorRoute(){
    return MaterialPageRoute(
      settings: RouteSettings(name: '/error'),

        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(child: Text('Something went wrong'),),
        ));
  }
}