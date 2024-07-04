import 'package:flutter/material.dart';
import 'package:reddit_clone/auth/sign_in_screen.dart';
import 'package:reddit_clone/posts/add_post_type_screen.dart';
import 'package:reddit_clone/screens/community_homescreen.dart';
import 'package:reddit_clone/screens/community_screen.dart';
import 'package:reddit_clone/screens/edit_community_screen.dart';
import 'package:reddit_clone/screens/edit_mod_screen.dart';
import 'package:reddit_clone/screens/edit_profile_screen.dart';
import 'package:reddit_clone/screens/home_screen.dart';
import 'package:reddit_clone/screens/modtools_screen.dart';
import 'package:reddit_clone/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: SignIn()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: HomeScreen()),
   '/create-community': (_) => MaterialPage(child: CreateCommunityScreen()),

   '/r/:name' :  (route) => MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!)),
   '/mod-tools/:name': (routeData) => MaterialPage(child: ModToolsScreen(
    name: routeData.pathParameters['name']!,
   )),
   '/edit-community/:name': (routeData) => MaterialPage(child: EditCommunityScreen(
    name: routeData.pathParameters['name']!,
   )),
   '/add-mods/:name': (routeData) => MaterialPage(child: AddModsScreen(
    name: routeData.pathParameters['name']!,
   )),
   '/prof-screen/:uid': (routeData) => MaterialPage(child: UserProfileScreen(
    uid: routeData.pathParameters['uid']!,
   )),
    '/edit-profile/:uid': (routeData) => MaterialPage(child: EditProfileScreen(
    uid: routeData.pathParameters['uid']!,
   )),
     '/add-post/:type': (routeData) => MaterialPage(child: AddPostTypeScreen(
    type: routeData.pathParameters['type']!,
   )),
   
});