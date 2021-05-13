import 'dart:async';

import 'package:flutter_app_instaclone/bloc/auth/auth_bloc.dart';
import 'package:flutter_app_instaclone/models/failure_model.dart';
import 'package:flutter_app_instaclone/models/post_model.dart';
import 'package:flutter_app_instaclone/repositories/post/post_repository.dart';
import 'package:flutter_app_instaclone/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_app_instaclone/models/user_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  StreamSubscription<List<Future<Post>>> _postsSubscription;

  ProfileBloc(
      {@required UserRepository userRepository,
        @required PostRepository postRepository,
        @required AuthBloc authBloc})
      : _userRepository = userRepository,
  _postRepository = postRepository,
        _authBloc = authBloc,
        super(ProfileState.initial());


  @override
  Future<void> close() {

    _postsSubscription.cancel();
    return super.close();
  }
  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    } else if (event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewToState(event);
    } else if(event is ProfileUpdatePosts){
      yield* _mapProfileUpdatePostsToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loaded);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == event.userId;
      _postsSubscription?.cancel();
      _postsSubscription = _postRepository.getUserPosts(userId: event.userId).listen((posts) async{
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts:allPosts));
      });
      yield state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        status: ProfileStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(status: ProfileStatus.error,
          failure: Failure(message: 'We were unable to load this profile'));
    }
  }

  Stream<ProfileState> _mapProfileToggleGridViewToState(
      ProfileToggleGridView event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

 Stream<ProfileState> _mapProfileUpdatePostsToState(ProfileUpdatePosts event) async*{
    yield state.copyWith(posts: event.posts);
 }
}
