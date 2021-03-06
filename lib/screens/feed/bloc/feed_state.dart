part of 'feed_bloc.dart';


enum FeedStatus { initial,pagination, loading, loaded, error }

class FeedState extends Equatable {
  final List<Post> posts;
  final FeedStatus status;
  final Failure failure;

  FeedState({
    @required this.posts,
    @required this.status,
    @required this.failure,
  });


  factory FeedState.initial(){
    return FeedState(posts: [], status: FeedStatus.initial, failure: Failure());
  }
  @override
  // TODO: implement props
  List<Object> get props =>
      [posts,
        status,
        failure,
      ];

  FeedState copyWith({
    List<Post> posts,
    FeedStatus status,
    Failure failure,
}){
   return FeedState(posts: posts ?? this.posts,
        status: status ?? this.status,
        failure: failure ?? this.failure,
    );

}
}