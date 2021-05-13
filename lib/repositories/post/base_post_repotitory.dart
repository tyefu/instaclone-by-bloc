import 'package:flutter_app_instaclone/models/comment_model.dart';
import 'package:flutter_app_instaclone/models/post_model.dart';

abstract class BasePostRepository{
  Future<void> createPost({Post post});
  Future<void> createComment({Comment comment});
  Stream<List<Future<Post>>> getUserPosts({String userId});
  Stream<List<Future<Comment>>> getPostComments({String postId});
}