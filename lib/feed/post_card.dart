import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/model/post_model.dart';
import 'package:reddit_clone/posts/controller.dart';


class PostCard extends ConsumerWidget {
  final PostModel post;
  const PostCard(  {super.key,required this.post,});

  void deletePost (WidgetRef ref,BuildContext context,){
    ref.read(postControllerProvider.notifier).deletePost(post,context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    return Column(
      children: [
        Column(children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(post.communityProfilePic),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.userName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        Text(post.communityName.toLowerCase(),style: TextStyle(fontSize: 14),),
                      ],
                    ),
                  ),
                
                ],
              ),
                if(post.uid == user.uid)
                  IconButton(onPressed: (){deletePost(ref,context);}, icon: Icon(Icons.delete,color: Colors.red,))
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(post.title)),
          if(isTypeImage)
          SizedBox(
            width: double.infinity,
            height: 250,
           child: Image(
            fit: BoxFit.cover,
            image: NetworkImage(post.link!)),
          ),
          if(isTypeText)
          SizedBox(
            width: double.infinity,
            
           child:Text(post.description!),
          ),
          Row(children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.favorite_rounded)),
            Text("Vote"),

            IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border_rounded)),
            Text("DownVote"),
            IconButton(onPressed: (){}, icon: Icon(Icons.comment)),
            Text("Comment")
          ],),
          Divider(color: Colors.white,)
        ],),
      ],
    );
  }
}