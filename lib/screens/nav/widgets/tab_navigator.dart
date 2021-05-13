import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/bloc/auth/auth_bloc.dart';
import 'package:flutter_app_instaclone/config/custom_router.dart';
import 'package:flutter_app_instaclone/enums/bottom_nav_item.dart';
import 'package:flutter_app_instaclone/repositories/post/post_repository.dart';
import 'package:flutter_app_instaclone/repositories/storage/storage_repository.dart';
import 'package:flutter_app_instaclone/repositories/user/user_repository.dart';
import 'package:flutter_app_instaclone/screens/create_post/create_post_screen.dart';
import 'package:flutter_app_instaclone/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter_app_instaclone/screens/feed/feed_screen.dart';
import 'package:flutter_app_instaclone/screens/notification/notification_screen.dart';
import 'package:flutter_app_instaclone/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_app_instaclone/screens/profile/profile_screen.dart';
import 'package:flutter_app_instaclone/screens/search/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator(
      {Key key, @required this.navigatorKey, @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute](context)),
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }
}

Widget _getScreen(BuildContext context, BottomNavItem item) {
  switch (item) {
    case BottomNavItem.feed:
      return FeedScreen();
    case BottomNavItem.search:
      return SearchScreen();
    case BottomNavItem.create:
      return BlocProvider<CreatePostCubit>(
          create: (context) => CreatePostCubit(
                postRepository: context.read<PostRepository>(),
                storageRepository: context.read<StorageRepository>(),
                authBloc: context.read<AuthBloc>(),
              ),
          child: CreatePostScreen());
    case BottomNavItem.notification:
      return NotificationScreen();
    case BottomNavItem.profile:
      return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>(),
              postRepository: context.read<PostRepository>())
            ..add(ProfileLoadUser(
                userId: context.read<AuthBloc>().state.user.uid)),
          child: ProfileScreen());
    default:
      return Scaffold();
  }
}
