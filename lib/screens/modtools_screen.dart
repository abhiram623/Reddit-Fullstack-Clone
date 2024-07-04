import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({super.key, required this.name});
  final String name;

  void navigateToEditCommunity(BuildContext context){
Routemaster.of(context).push('/edit-community/$name');
  }
    void navigateToAddModsScreen(BuildContext context){
Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mod Tools"),
      ),
      body: Column(children: [
        ListTile(
          title: Text("Add Moderators"),
        leading: Icon(Icons.add_moderator),
        onTap: () {
          navigateToAddModsScreen(context);
        },
        ),
        ListTile(
          title: Text("Edit Community"),
        leading: Icon(Icons.edit),
        onTap: () {
          navigateToEditCommunity(context);
        },
        )
      ],),
    );
  }
}