import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/config/custom_router.dart';
import 'package:flutter_app_instaclone/enums/bottom_nav_item.dart';
import 'package:flutter_app_instaclone/screens/create_post/create_post_screen.dart';
import 'package:flutter_app_instaclone/screens/feed/feed_screen.dart';
import 'package:flutter_app_instaclone/screens/notification/notification_screen.dart';
import 'package:flutter_app_instaclone/screens/profile/profile_screen.dart';
import 'package:flutter_app_instaclone/screens/search/search_screen.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key key, @required this.navigatorKey, @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_,initialRoute){
        return[
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute](context)),
        ];
      },

      onGenerateRoute:CustomRouter.onGenerateRoute ,
    );
  }
  Map<String,WidgetBuilder> _routeBuilders(){
    return{tabNavigatorRoot:(context) => _getScreen(context,item)};
  }
  }

Widget _getScreen(BuildContext context, BottomNavItem item) {
  switch(item){
    case BottomNavItem.feed:
      return FeedScreen();
    case BottomNavItem.search:
      return SearchScreen();
    case BottomNavItem.create:
      return CreatePostScreen();
    case BottomNavItem.notification:
      return NotificationScreen();
    case BottomNavItem.profile:
      return ProfileScreen();
    default:
      return Scaffold();
  }
}
