import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/community/controller.dart';
import 'package:reddit_clone/feed/post_card.dart';
import 'package:reddit_clone/loader.dart';
import 'package:reddit_clone/posts/controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(data:(data) {
      return ref.watch(userPostsProvider(data)).when(data:(postData) {
        return ListView.builder(
          itemCount: postData.length,

          itemBuilder: (context, index) {
            final post = postData[index];
            return PostCard(post: post);
          },);
      }, error: (error, stackTrace) {
        print(error);
         return Center(child: Text(error.toString()),);
      }, loading: () {
        return Loader();
      },);
    }, error: (error, stackTrace) {
      return Center(child: Text(error.toString()),);
    }, loading: () {
      return Loader();
    },);
  }
}