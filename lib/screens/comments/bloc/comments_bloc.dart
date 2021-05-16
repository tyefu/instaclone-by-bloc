import 'dart:async';

import 'package:flutter_app_instaclone/models/user_model.dart';
import 'package:flutter_app_instaclone/repositories/post/post_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_instaclone/models/comment_model.dart';
import 'package:flutter_app_instaclone/models/post_model.dart';
import 'package:flutter_app_instaclone/models/failure_model.dart';
import 'package:flutter_app_instaclone/bloc/auth/auth_bloc.dart';

part 'comments_state.dart';

part 'comments_event.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostRepository _postRepository;
  final AuthBloc _autuBloc;

  StreamSubscription<List<Future<Comment>>> _commentsSubscription;

  CommentsBloc({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _autuBloc = authBloc,
        super(CommentsState.initial());

  @override
  Future<void> close() {
    // TODO: implement close
    _commentsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<CommentsState> mapEventToState(CommentsEvent event) async* {
    // TODO: implement mapEventToState
    if (event is CommentsFetchComments) {
      yield* _mapCommentsFetchCommentsToState(event);
    } else if (event is CommentUpdateComments) {
      yield* _mapCommentsUpdateCommentsToState(event);
    } else if (event is CommentsPostComment) {
      yield* _mapCommentsPostCommentToState(event);
    }
  }

  Stream<CommentsState> _mapCommentsFetchCommentsToState(
      CommentsFetchComments event) async* {
    yield state.copyWith(status: CommentsStatus.loading);
    try {
      _commentsSubscription?.cancel();
      _commentsSubscription = _postRepository
          .getPostComments(postId: event.post.id)
          .listen((comments) async {
        final allComments = await Future.wait(comments);
        add(CommentUpdateComments(comments: allComments));
      });
      yield state.copyWith(post: event.post, status: CommentsStatus.loaded);
    } catch (err) {
      yield state.copyWith(
          status: CommentsStatus.error,
          failure: const Failure(
              message: 'We were unable to load this post\'s comments'));
    }
  }

  Stream<CommentsState> _mapCommentsUpdateCommentsToState(
      CommentUpdateComments event) async* {
    yield state.copyWith(comments: event.comments);
  }

  Stream<CommentsState> _mapCommentsPostCommentToState(
      CommentsPostComment event) async* {
    yield state.copyWith(status: CommentsStatus.submitting);
    try {
      final author = User.empty.copyWith(id: _autuBloc.state.user.uid);
      final comment = Comment(
          postId: state.post.id,
          author: author,
          content: event.content,
          date: DateTime.now());
      await _postRepository.createComment(comment: comment);
      yield state.copyWith(status: CommentsStatus.loaded);
    } catch (err) {
      yield state.copyWith(
          status: CommentsStatus.error,
          failure: const Failure(message: 'Comment failed to post'));
    }
  }
}
