import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/bloc/auth/auth_bloc.dart';
import 'package:flutter_app_instaclone/screens/login/login_screen.dart';
import 'package:flutter_app_instaclone/screens/nav/nav_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name:routeName ),
        builder: (_) => SplashScreen());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async => false,
      child: BlocListener<AuthBloc,AuthState>(
        listener: (context,state){
          if(state.status == AuthStatus.unauthenticated){

            Navigator.of(context).pushNamed(LoginScreen.routeName);
          }else if (state.status == AuthStatus.authenticated){
            Navigator.of(context).pushNamed(NavScreen.routeName);
          }
          print(state);
        },
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
