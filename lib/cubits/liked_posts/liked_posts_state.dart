part of'liked_posts_cubit.dart';



class LikedPostsState extends Equatable {
  final Set<String> likedPostIds;
  final Set<String> recentlyLikedPostIds;

  LikedPostsState(
      {@required this.likedPostIds, @required this.recentlyLikedPostIds});


  factory LikedPostsState.initial(){
    return LikedPostsState(likedPostIds: {}, recentlyLikedPostIds: {});
  }
  @override
  // TODO: implement props
  List<Object> get props => [likedPostIds, recentlyLikedPostIds];

  LikedPostsState copyWith({
    Set<String> likedPostIds,
    Set<String> recentlyLikedPostIds,
  }) {
    return LikedPostsState(
      likedPostIds: likedPostIds ?? this.likedPostIds,
      recentlyLikedPostIds: recentlyLikedPostIds ?? this.recentlyLikedPostIds,
    );
  }

}