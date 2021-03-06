import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_instaclone/cubits/liked_posts/liked_posts_cubit.dart';

import 'package:flutter_app_instaclone/models/failure_model.dart';
import 'package:flutter_app_instaclone/models/post_model.dart';
import 'package:flutter_app_instaclone/repositories/post/post_repository.dart';
import 'package:flutter_app_instaclone/bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_state.dart';

part 'feed_event.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  FeedBloc({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
    @required LikedPostsCubit likedPostsCubit,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FeedState.initial());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is FeedFetchPosts) {
      yield* _mapFeedFetchPostsToState();
    } else if (event is FeedPaginatePosts) {
      yield* _mapFeedPaginatePostsToState();
    }
  }

  Stream<FeedState> _mapFeedFetchPostsToState() async* {
    yield state.copyWith(posts: [], status: FeedStatus.loading);
    try {
      final posts =
          await _postRepository.getUserFeed(userId: _authBloc.state.user.uid);
      _likedPostsCubit.clearAllLikedPosts();
      final likedPostIds = await _postRepository.getLikedPostIds(
          userId: _authBloc.state.user.uid, posts: posts);
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
      yield state.copyWith(posts: posts, status: FeedStatus.loaded);
    } catch (err) {
      yield state.copyWith(
          status: FeedStatus.error,
          failure: const Failure(message: 'We were unable to load your feed'));
    }
  }

  Stream<FeedState> _mapFeedPaginatePostsToState() async* {
    yield state.copyWith(status: FeedStatus.pagination);
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last.id : null;
      final posts = await _postRepository.getUserFeed(
          userId: _authBloc.state.user.uid, lastPostId: lastPostId);
      final updatePosts = List<Post>.from(state.posts)..addAll(posts);

      final likedPostIds = await _postRepository.getLikedPostIds(
          userId: _authBloc.state.user.uid, posts: posts);
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
      yield state.copyWith(posts: updatePosts, status: FeedStatus.loaded);
    } catch (err) {
      print(err);
      yield state.copyWith(
          status: FeedStatus.error,
          failure: const Failure(message: 'We were unable to load your feed'));
    }
  }
}
