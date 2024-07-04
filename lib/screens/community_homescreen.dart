import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/community/controller.dart';
import 'package:reddit_clone/loader.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key,required this.name, });
  final String name;

  void navigateToModTools (BuildContext context){
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref,Community community,BuildContext context){
ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body:  ref.watch(getCommunityByNameProvider(name)).when(data:(data) {
        return NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
              SliverAppBar(
              expandedHeight: 150,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(child: Image.network(data.banner,fit: BoxFit.cover,))
                ],
              ),),
              SliverPadding(padding: EdgeInsets.all(10),
              sliver: SliverList(delegate:SliverChildListDelegate(
                [
                Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(data.avatar),
                  ),
                )  ,
                Padding(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Text(data.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),

                  data.mods.contains(user.uid)
                  ?
                   OutlinedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10),),
                    onPressed: (){
                      navigateToModTools(context);
                    }, child: Text('Mod Tools',style: TextStyle(fontWeight: FontWeight.w600,),))
                    :
                     OutlinedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10),),
                    onPressed: (){
                      joinCommunity(ref, data, context);
                    }, child: Text(data.members.contains(user.uid) ?'Joined' : 'Join',style: TextStyle(fontWeight: FontWeight.w600,),))
                  ],
                ),
                ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8),
                     child: Text('${data.members.length} member',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                   )
                ]
              )),
              )
          ];
        }, body: Text("Displaying post"));
      }, error: (error, stackTrace) {
        return Center(child: Text(error.toString()),);
      }, loading: () {
        return Loader();
      },),
    );
  }
}