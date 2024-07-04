import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/community/storage_respository.dart';
import 'package:reddit_clone/model/post_model.dart';
import 'package:reddit_clone/posts/repository.dart';
import 'package:reddit_clone/show_snackbar.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final userPostsProvider = StreamProvider.family((ref,List<Community> communities)  {
  return ref.watch(postControllerProvider.notifier).getUserPosts(communities);
});

final postControllerProvider = StateNotifierProvider<PostController,bool>((ref) {
  return PostController(postRespository: ref.watch(postRespositoryProvider), ref: ref, storageRepository: ref.watch(StorageRepositoryProvider));
});

class PostController extends StateNotifier<bool> {
  final PostRespository postRespository;
  final Ref ref;
  final StorageRepository storageRepository;

  PostController(
      {required this.postRespository,
      required this.ref,
      required this.storageRepository})
      : super(false);

  void shareTextPost(
      {required String title,
      required String description,
      required Community selectedCommunity,
      required BuildContext context}) async {
    state = true;
    String postid = Uuid().v1();
    final user = ref.read(userProvider)!;
    final PostModel postModel = PostModel(
        id: postid,
        title: title,
        description: description,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upVotes: [],
        downVotes: [],
        userName: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: []);

    final res = await postRespository.addPost(postModel);
    state = false;
    res.fold(
        (l) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.message))), (r) {
      showSnackBar(context, 'Posted SuccessFully');
      Routemaster.of(context).pop();
    });
  }

  void sharelinkPost(
      {required String title,
      required String link,
      required Community selectedCommunity,
      required BuildContext context}) async {
    state = true;
    String postid = Uuid().v1();
    final user = ref.read(userProvider)!;
    final PostModel postModel = PostModel(
        id: postid,
        title: title,
        link: link,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upVotes: [],
        downVotes: [],
        userName: user.name,
        uid: user.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: []);

    final res = await postRespository.addPost(postModel);
    state = false;
    res.fold(
        (l) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.message))), (r) {
      showSnackBar(context, 'Posted SuccessFully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required String title,
      required File? file,
      required Community selectedCommunity,
      required BuildContext context}) async {
    state = true;
    String postid = Uuid().v1();
    final user = ref.read(userProvider)!;

    final imageRes = await storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postid, file: file);
    imageRes.fold((l) {
      showSnackBar(context, l.message);
    }, (r) async {
      final PostModel postModel = PostModel(
          id: postid,
          title: title,
          link: r,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upVotes: [],
          downVotes: [],
          userName: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: []);

      final res = await postRespository.addPost(postModel);
      state = false;
      res.fold(
          (l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))), (r) {
        showSnackBar(context, 'Posted SuccessFully');
        Routemaster.of(context).pop();
      });
    });
  }
   Stream<List<PostModel>> getUserPosts(List<Community> communities){
    if (communities.isNotEmpty) {
     return postRespository.getUserPosts(communities); 
    }else{
     return  Stream.value([]);
    }
    

   }

   void deletePost (PostModel post,BuildContext context)async{
   final res = await postRespository.deletePost(post);
   res.fold((l) {showSnackBar(context, l.message);}, (r) => null);
   }
}
