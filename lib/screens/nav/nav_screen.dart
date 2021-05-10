import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/enums/bottom_nav_item.dart';
import 'package:flutter_app_instaclone/screens/nav/cubit/bottom_navbar_cubit.dart';
import 'package:flutter_app_instaclone/screens/nav/widgets/bottom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route(){
    return PageRouteBuilder(settings:RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_,__,___) => BlocProvider<BottomNavBarCubit>

          (create: (_) => BottomNavBarCubit(),
            child: NavScreen()));

  }


  final Map<BottomNavItem,GlobalKey<NavigationState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notification: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };


  final Map<BottomNavItem,IconData> items = const{
    BottomNavItem.feed:Icons.home,
    BottomNavItem.search:Icons.search,
    BottomNavItem.create:Icons.add,
    BottomNavItem.notification:Icons.favorite_border,
    BottomNavItem.profile:Icons.account_circle,

  };
  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: ()async => false,
      child: BlocBuilder<BottomNavBarCubit,BottomNavBarState>(
        builder: (context,state) {
          return Scaffold(
            body: Text('nav Screen'),
            bottomNavigationBar: BottomNavBar(selectedItem: BottomNavItem.feed,
              items: items,
              onTap: (index) {
                print(index);
                final selectedItem = BottomNavItem.values[index];
                context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
              },

            ),
          );
        },
      ),
    );
    }
}
