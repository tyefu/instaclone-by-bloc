import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route(){
    return PageRouteBuilder(settings:RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_,__,___) => NavScreen());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('nav Screen'),
    );
  }
}
