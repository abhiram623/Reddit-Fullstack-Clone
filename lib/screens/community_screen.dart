import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/community/controller.dart';
import 'package:reddit_clone/loader.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final TextEditingController communityController = TextEditingController();
  @override
  void dispose() {
    communityController.dispose();
    super.dispose();
  }

  void createCommunity (){
    ref.read(communityControllerProvider.notifier).createCommunity(communityController.text.trim(), context);
  }
  

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("Create a community"),
      ),
      body: isLoading ? Loader() : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text("Community name",style: TextStyle(fontWeight: FontWeight.w400),)),
            SizedBox(height: 15,),
            TextField(
              controller: communityController,
              decoration: InputDecoration(
                hintText: "Community name",
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0,color:Colors.transparent ),
                  borderRadius: BorderRadius.circular(20)
                  ),
                   enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0,color:Colors.transparent ),
                  borderRadius: BorderRadius.circular(20)
                  ),
                filled: true,
                
                

                ),
                maxLength: 21,
              
            ),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: (){
              createCommunity();
            },
             child: Text('Create community'),
             style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            )
          ],
        ),
      ),
    );
  }
}