import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/typedef.dart';
import 'package:reddit_clone/model/usermodel.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firebaseFirestore: FirebaseFirestore.instance);
});

class UserProfileRepository {
   final FirebaseFirestore firebaseFirestore;
  UserProfileRepository({required this.firebaseFirestore});

CollectionReference get users => firebaseFirestore.collection('users');

FutureVoid editProfile (UserModel user) async{
  try {
    return right(users.doc(user.uid).update(user.toMap()));
  } on FirebaseAuthException catch(e){
    throw e.message!;
  } catch (e) {
  return left(Failure(e.toString()));
  }
}
}