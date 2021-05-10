import 'package:flutter_app_instaclone/enums/bottom_nav_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
part 'bottom_navbar_state.dart';


class BottomNavBarCubit extends Cubit<BottomNavBarState>{
  BottomNavBarCubit() : super(BottomNavBarState(selectedItem:BottomNavItem.feed ));

  void updateSelectedItem(BottomNavItem item){
    if(item != state.selectedItem){
      emit(BottomNavBarState(selectedItem: item));
    }
  }
}