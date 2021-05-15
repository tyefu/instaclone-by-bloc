import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_instaclone/models/failure_model.dart';
import 'package:flutter_app_instaclone/models/user_model.dart';
import 'package:flutter_app_instaclone/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;

  SearchCubit({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchState.initial());

  void searchUsers(String query) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final users = await _userRepository.searchUsers(query: query);
      emit(state.copyWith(users: users, status: SearchStatus.loaded));
    } catch (err) {
      state.copyWith(status: SearchStatus.error, failure: Failure(
        message: 'Something went wrong. Please try again'
      ));
    }
  }
  void clearSearch(){
    emit(state.copyWith(users: [],status: SearchStatus.initial));
  }
}
