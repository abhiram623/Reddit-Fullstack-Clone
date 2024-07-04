import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/constants.dart';
import 'package:reddit_clone/delegates/search_community_delegates.dart';
import 'package:reddit_clone/screens/community_drawer.dart';
import 'package:reddit_clone/screens/profile_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedPage = 0;

  void onPageChanged (int page){
    setState(() {
      selectedPage = page;
    });
  }

  void displayEndDrawer (BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userProvider)!;
    return Scaffold(
      endDrawer: ProfileDrawer(),
      drawer: CommunityListDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.white,
        
        currentIndex: selectedPage,
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        items:[
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "",),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: ""),
        ],
        onTap: onPageChanged,
        
        ),
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: (){showSearch(context: context, delegate: SearchhCommunityDelegates(ref));}, icon:Icon(Icons.search)),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: (){
               displayEndDrawer(context);
                },
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              );
            }
          )
        ],

      ),
      body:Constants.tabWidgets[selectedPage]

    );
  }
}