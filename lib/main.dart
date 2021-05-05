import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/bloc/auth_bloc.dart';
import 'package:flutter_app_instaclone/bloc/simple_bloc_observer.dart';
import 'package:flutter_app_instaclone/config/custom_router.dart';
import 'package:flutter_app_instaclone/repositories/auth/auth_repository.dart';
import 'package:flutter_app_instaclone/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository(),
        ) ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) =>
      AuthBloc(authRepository: context.read<AuthRepository>()),
          ) ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme(
                headline6: TextStyle(color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),

              )
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
         initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}

