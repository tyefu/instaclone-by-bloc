import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_instaclone/models/post_model.dart';
import 'package:flutter_app_instaclone/repositories/post/post_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_instaclone/bloc/auth/auth_bloc.dart';

part 'liked_posts_state.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  LikedPostsCubit({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(LikedPostsState.initial());

  void updateLikedPosts({@required Set<String> postIds}) {
    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds),
    ));
  }

  void likePost({@required Post post}) {
    _postRepository.createLike(post: post, userId: _authBloc.state.user.uid);
    emit(
      state.copyWith(
          likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id),
          recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
            ..add(post.id)),
    );
  }

  void unlikePost({@required Post post}) {
    _postRepository.deleteLike(
        postId: post.id, userId: _authBloc.state.user.uid);
    emit(
      state.copyWith(
          likedPostIds: Set<String>.from(state.likedPostIds)..remove(post.id),
          recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
            ..remove(post.id)),
    );
  }

  void clearAllLikedPosts() {
    emit(LikedPostsState.initial());
  }
}
