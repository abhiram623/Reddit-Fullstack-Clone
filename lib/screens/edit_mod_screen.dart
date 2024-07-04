import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/community/controller.dart';
import 'package:reddit_clone/error_screen.dart';
import 'package:reddit_clone/loader.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {

   Set <String> uids = {};
   int ctr = 0;

   void addUid (String uid){
    setState(() {
      uids.add(uid);
    });
   }
    void removeUid (String uid){
    setState(() {
      uids.remove(uid);
    });
   }

   void saveMods (BuildContext context){
    ref.watch(communityControllerProvider.notifier).addMods(widget.name, uids.toList(), context);
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {saveMods( context);}, icon: Icon(Icons.done))],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (communityData) {
          return ListView.builder(
            itemCount: communityData.members.length,
            itemBuilder: (context, index) {
            return  ref
                  .watch(getUserDataFromFirebaseProvider(
                      communityData.members[index]))
                  .when(
                    data: (userData) {
                      if (communityData.mods.contains(userData.uid) && ctr == 0) {
                        uids.add(userData.uid);
                      }
                      ctr++;
                      return   CheckboxListTile(
                value: uids.contains(userData.uid) ,
                onChanged: (value) {
                  if (value!) {
                    addUid(userData.uid);
                  }
                  else{
                    removeUid(userData.uid);
                  }
                },
                title: Text(userData.name),
              );
                    },
                    error: (error, stackTrace) {
                      return ErrorScreen(error: error.toString());
                    },
                    loading: () {
                      return Loader();
                    },
                  );
             
            },
          );
        },
        error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        },
        loading: () {
          return Loader();
        },
      ),
    );
  }
}
