import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/community/controller.dart';
import 'package:reddit_clone/error_screen.dart';
import 'package:reddit_clone/loader.dart';
import 'package:routemaster/routemaster.dart';


class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCommunity(BuildContext context){
    Routemaster.of(context).push('/create-community');
  }
  void navigateToCommunityHome(BuildContext context,Community community){
     Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Drawer(
      child: SafeArea(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
              navigateToCommunity(context);
              },
              title: Text("Create a community"),
              leading: IconButton(onPressed: (){}, icon: Icon(Icons.add)),
            ),
          ),
          ref.watch(userCommunitiesProvider).when(data:(data) {
            return Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                    navigateToCommunityHome(context, data[index]);
                    },
                    title: Text(data[index].name),
                    leading: CircleAvatar(backgroundImage: NetworkImage(data[index].avatar),),
                  );
                },),
            );
          }, error:(error, stackTrace) {
          return  ErrorScreen(error: error.toString());
          }, loading:() {
           return Loader();
          },)
        ],
      )),
    );
  }
}