import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/typedef.dart';
import 'package:reddit_clone/model/post_model.dart';

final postRespositoryProvider = Provider((ref) {
  return PostRespository(firebaseFirestore: FirebaseFirestore.instance) ;
});
class PostRespository {
  final FirebaseFirestore firebaseFirestore;

  PostRespository({required this.firebaseFirestore});

  CollectionReference get posts => firebaseFirestore.collection('posts');

  FutureVoid addPost (PostModel postModel)async{
    try {
      return right(posts.doc(postModel.id).set(postModel.toMap() as Map<String,dynamic>));
    }on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> getUserPosts(List<Community> communities){
  return posts.where('communityName',whereIn: communities.map((e) => e.name).toList()).orderBy('createdAt',descending: true).snapshots().map((event) {
    List<PostModel> postList = [];
    for (var doc in event.docs) {
      postList.add(PostModel.fromMap(doc.data() as Map<String,dynamic>));
    }
    return postList;
  });
  }
  FutureVoid deletePost (PostModel post)async{
try {
  return right(posts.doc(post.id).delete());
}on FirebaseAuthException catch (e) {
  throw e.message!;
} catch (e) {
  return left(Failure(e.toString()));
}
  }
  
}