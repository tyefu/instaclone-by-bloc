import 'package:flutter/material.dart';
import 'package:flutter_app_instaclone/screens/feed/bloc/feed_bloc.dart';
import 'package:flutter_app_instaclone/widgets/error_dialog.dart';
import 'package:flutter_app_instaclone/widgets/post_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange && context
            .read<FeedBloc>()
            .state
            .status != FeedStatus.pagination) {
          context.read<FeedBloc>().add(FeedPaginatePosts());
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
              context: context,
              builder: (context) =>
                  ErrorDialog(content: state.failure.message));
        }else if(state.status == FeedStatus.pagination){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 1),
            content: const Text('Fetching More Posts...'),
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Instagram'),
            actions: [
              if (state.posts.isEmpty && state.status == FeedStatus.loaded)
                IconButton(
                    onPressed: () =>
                        context.read<FeedBloc>().add(FeedFetchPosts()),
                    icon: const Icon(Icons.refresh))
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPosts());
            return true;
          },
          child: ListView.builder(
            controller: _scrollController,
              itemCount: state.posts.length,
              itemBuilder: (BuildContext context, int index) {
                final post = state.posts[index];
                return PostView(post: post, isLiked: false);
              }),
        );
    }
  }
}
