import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/community/controller.dart';
import 'package:reddit_clone/loader.dart';
import 'package:routemaster/routemaster.dart';

class SearchhCommunityDelegates extends SearchDelegate {
  final WidgetRef ref;

  SearchhCommunityDelegates(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
  return  ref.watch(searchCommunityProvider(query)).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder:(context, index) {
                return ListTile(
                  title: Text(data[index].name),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data[index].avatar),
                  ),
                  onTap: () {
                    navigateToCommunityHome(context, data[index]);
                  },
                );
              },);
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () {
            return Loader();
          },
        );
  }
   void navigateToCommunityHome(BuildContext context,Community community){
     Routemaster.of(context).push('/r/${community.name}');
  }
}
