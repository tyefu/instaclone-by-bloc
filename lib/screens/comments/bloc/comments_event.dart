
part of'comments_bloc.dart';
abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class CommentsFetchComments extends CommentsEvent {
  final Post post;

  const CommentsFetchComments({
    @required this.post
  });

  @override
  // TODO: implement props
  List<Object> get props => [post];


}
class CommentUpdateComments extends CommentsEvent{
final List<Comment> comments;

 const CommentUpdateComments({@required this.comments});
@override
// TODO: implement props
List<Object> get props => [comments];

}
class CommentsPostComment extends CommentsEvent{
  final String content;
  const CommentsPostComment({@required this.content});

  @override
// TODO: implement props
  List<Object> get props => [content];

}