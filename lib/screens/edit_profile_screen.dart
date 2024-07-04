import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/constants.dart';
import 'package:reddit_clone/loader.dart';
import 'package:reddit_clone/pick_image.dart';
import 'package:reddit_clone/user_profile/controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key,required this.uid, });
  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {

  File? bannerImage;
  File? avatharImage;
  late final TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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

   void save (){
    ref.read(userProfileControllerProvider.notifier).editProfile(context: context, profileFile: avatharImage, bannerFile: bannerImage, name: nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Community"),
        actions: [
          TextButton(onPressed: (){}, child: Text('Save'))
        ],
        
      ),
      body:ref.watch(getUserDataFromFirebaseProvider(widget.uid)).when(data: (userData) {
        return isLoading ? Loader():   Padding(
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
                                 child:bannerImage != null ? Image.file(bannerImage!): userData.banner.isEmpty || userData.banner == Constants.bannerDefault ? Center(child: Icon(Icons.camera_alt_outlined,size: 46,),) : Image.network(userData.banner),
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
                          backgroundImage: NetworkImage(userData.profilePic),
                        ),
                      ),
                    )
                 ],
               ),
             ),
             TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                hintText: "Name",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 1,color: Colors.blue)
                ),
                border: InputBorder.none
              ),
              
             ),
             ElevatedButton(onPressed: (){
              save();
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