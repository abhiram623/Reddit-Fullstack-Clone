import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToAddPostTypeScreen (BuildContext context,String type){
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        GestureDetector(
          onTap: () {
            navigateToAddPostTypeScreen(context, 'image');
          },
          child: SizedBox(
            height: 130,
            width: 130,
            child: Card(
              child: Icon(Icons.image,size: 55,),
            ),
          ),
        ),
          GestureDetector(
            onTap: () {
              navigateToAddPostTypeScreen(context, 'text');
            },
            child: SizedBox(
            height: 130,
            width: 130,
            child: Card(
              child: Icon(Icons.font_download_outlined,size: 55,),
            ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              navigateToAddPostTypeScreen(context, 'link');
            },
            child: SizedBox(
            height: 130,
            width: 130,
            child: Card(
              child: Icon(Icons.link_outlined,size: 55,),
            ),
                  ),
          )
      ],),
    );
  }
}