import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/community/controller.dart';
import 'package:reddit_clone/constants.dart';
import 'package:reddit_clone/loader.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:reddit_clone/pick_image.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  const EditCommunityScreen({super.key, required this.name});

 final String name;

  @override
  ConsumerState<EditCommunityScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerImage;
  File? avatharImage;

  void selectbannerImage ()async{
    bannerImage = await pickImageFromGallery();
    setState(() {
      
    });
  }
   void selectavatharImage ()async{
    avatharImage = await pickImageFromGallery();
    setState(() {
      
    });
  }

  void save (Community community){
    ref.read(communityControllerProvider.notifier).editCommunity(community: community, context: context, profileFile: avatharImage, bannerFile: bannerImage);
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Community"),
        actions: [
          TextButton(onPressed: (){}, child: Text('Save'))
        ],
        
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(data: (data) {
        return isLoading? Loader(): Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
             children: [
             SizedBox(
              height: 225,
               child: Stack(
                 children: [
                   GestureDetector(
                    onTap: () {
                      selectbannerImage();
                    },
                     child: DottedBorder(
                      color: Colors.white,
                      dashPattern: [10,4],
                      strokeCap: StrokeCap.round,
                      borderType: BorderType.RRect,
                       radius: Radius.circular(20),
                      padding: EdgeInsets.all(16),
                      child: ClipRRect(
                        child: Container(height: 150,width: double.infinity,
                                 decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                                 ),
                                 child:bannerImage != null ? Image.file(bannerImage!): data.banner.isEmpty || data.banner == Constants.bannerDefault ? Center(child: Icon(Icons.camera_alt_outlined,size: 46,),) : Image.network(data.banner),
                                 ),
                      )),
                   ),
                    Positioned(
                      bottom: 20,left: 20,
                      child: GestureDetector(
                        onTap: () {
                          selectavatharImage();
                        },
                        child:avatharImage != null?CircleAvatar(
                          radius: 30,
                          backgroundImage: FileImage(avatharImage!),
                        ) : CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(data.avatar),
                        ),
                      ),
                    )
                 ],
               ),
             ),
             ElevatedButton(onPressed: (){
              save(data);
             }, child: Text('save'))
             ],
          ),
        );
      },
      
       error:(error, stackTrace) {
        return Center(
          child:  Text(error.toString()),
        );
      }, loading: () {
        return Loader();
      },),
    );
  }
}