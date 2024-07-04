import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/loader.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen( {super.key,required this.uid,});
  final String uid;

  void navigateToEditProfile (BuildContext context){
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    
    return Scaffold(
      body:  ref.watch(getUserDataFromFirebaseProvider(uid)).when(data:(userData) {
        return NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
              SliverAppBar(
              expandedHeight: 250,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(child: Image.network(userData.banner,fit: BoxFit.cover,)),

                   Container(
                    
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(20).copyWith(bottom: 60),
                     child: CircleAvatar(
                       radius: 35,
                       backgroundImage: NetworkImage(userData.profilePic),
                     ),
                   )  ,

                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.bottomLeft,
                      child: OutlinedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10),),
                      onPressed: (){
                       navigateToEditProfile(context);
                      }, child: Text("Edit Profile",style: TextStyle(fontWeight: FontWeight.w600,),)),
                    )
                ],
              ),),
              SliverPadding(padding: EdgeInsets.all(10),
              sliver: SliverList(delegate:SliverChildListDelegate(
                [
               
                Padding(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Text(userData.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),

                 
                    
                  ],
                ),
                ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                     child: Text('${userData.karma} karma',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                   ),
                   SizedBox(height: 10,),
                   Divider(thickness: 2,)
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
