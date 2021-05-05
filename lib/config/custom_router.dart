import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/screens/login/login_screen.dart';
import 'package:flutter_app_instaclone/screens/nav/nav_screen.dart';
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