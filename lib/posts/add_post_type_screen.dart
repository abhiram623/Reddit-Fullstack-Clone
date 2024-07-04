import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/community/controller.dart';
import 'package:reddit_clone/loader.dart';
import 'package:reddit_clone/pick_image.dart';
import 'package:reddit_clone/posts/controller.dart';
import 'package:reddit_clone/show_snackbar.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  const AddPostTypeScreen({super.key, required this.type});
  final String type;

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  File? bannerImage;
  List<Community> communityList = [];
  Community? selectedCommunity;
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void selectbannerImage() async {
    bannerImage = await pickImageFromGallery();
    setState(() {});
  }

  void sharePost(){
    if (widget.type == 'image'  && titleController.text.isNotEmpty && bannerImage!= null) {
      ref.read(postControllerProvider.notifier).shareImagePost(title: titleController.text.trim(), file: bannerImage, selectedCommunity: selectedCommunity ?? communityList[0], context: context);
    }else if(widget.type == 'text'  && titleController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier).shareTextPost(title: titleController.text.trim(), description: descriptionController.text.trim(), selectedCommunity: selectedCommunity ?? communityList[0], context: context);
    }else if(widget.type == 'link'  && titleController.text.isNotEmpty && linkController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier).sharelinkPost(title: titleController.text.trim(), link: linkController.text.trim(), selectedCommunity:  selectedCommunity ?? communityList[0], context: context);
    }else{
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
     final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Post ${widget.type}"),
        actions: [TextButton(onPressed: () {sharePost();}, child: Text("Share"))],
      ),
      body:isLoading? Loader() : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              maxLength: 30,
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter Title Here",
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20)),
                filled: true,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (isTypeImage)
              GestureDetector(
                onTap: () {
                  selectbannerImage();
                },
                child: DottedBorder(
                    color: Colors.white,
                    dashPattern: [10, 4],
                    strokeCap: StrokeCap.round,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    padding: EdgeInsets.all(16),
                    child: ClipRRect(
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: bannerImage != null
                            ? Image.file(bannerImage!)
                            : Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 46,
                                ),
                              ),
                      ),
                    )),
              ),
            if (isTypeText)
              TextField(
                maxLines: 5,
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Enter description here",
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  filled: true,
                ),
              ),
            if (isTypeLink)
              TextField(
                maxLines: 5,
                controller: linkController,
                decoration: InputDecoration(
                  hintText: "Paste link here",
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  filled: true,
                ),
              ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Select Community",
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
            ref.watch(userCommunitiesProvider).when(
              data: (data) {
                communityList = data;

                return DropdownButton(
                  value: selectedCommunity ?? data[0],
                  items: data
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCommunity = value;
                    });
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(error.toString()),
                );
              },
              loading: () {
                return Loader();
              },
            )
          ],
        ),
      ),
    );
  }
}
