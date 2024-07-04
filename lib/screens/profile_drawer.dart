import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  

  void logOut (WidgetRef ref){
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfileScreen (String uid,BuildContext context){
    Routemaster.of(context).push('/prof-screen/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
             radius: 45, 
              backgroundImage: NetworkImage(user.profilePic),
            ),
          ),
          Text(user.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
          Divider(thickness: 2,),
          ListTile(leading: Icon(Icons.person),title: Text('My Profile',style: TextStyle(fontWeight: FontWeight.w500),),onTap: () {
            navigateToUserProfileScreen(user.uid, context);
          },),
          ListTile(leading: Icon(Icons.logout_outlined),title: Text('Log Out',style: TextStyle(fontWeight: FontWeight.w500),),onTap: () {
            logOut(ref);
          },),
          Switch.adaptive(value: true, onChanged: (value) {
            
          },)
        ],
      )),
    );
  }
}