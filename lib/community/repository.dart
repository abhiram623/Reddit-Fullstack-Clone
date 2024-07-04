import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/typedef.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommuntiyRepository(firebaseFirestore: FirebaseFirestore.instance);
});

class CommuntiyRepository {
  final FirebaseFirestore firebaseFirestore;
  

  CommuntiyRepository({required this.firebaseFirestore});
  
FutureVoid createCommunity (Community community) async{
  try {

    var communityDoc = await communities.doc(community.name).get();
    if (communityDoc.exists) {
      throw 'Community with same already exists';
    }
    return right(communities.doc(community.name).set(community.toMap()));
    
  }on FirebaseAuthException catch (e){
    return left(Failure(e.message!));
  } catch (e) {
    return left(Failure(e.toString()));
  }
}

Stream<Community> getCommunityByName (String name){
  return communities.doc(name).snapshots().map((event) => Community.fromMap(event.data() as Map<String,dynamic>));
}


Stream<List<Community>> getUserCommunities (String uid ){
return communities.where('members', arrayContains: uid).snapshots().map((event) {
  List<Community> communityList = [];
  for (var doc in event.docs) {
    communityList.add(Community.fromMap(doc.data() as Map<String,dynamic>));
  }
  return communityList;
});
}

FutureVoid editCommunity (Community community) async{
  try {
    return right(communities.doc(community.name).update(community.toMap()));
  } on FirebaseAuthException catch(e){
    throw e.message!;
  } catch (e) {
  return left(Failure(e.toString()));
  }
}

Stream < List<Community>> searchCommunity (String query){
  return communities.where(
    'name' ,
     isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
     isLessThan: query.isEmpty ? null : query.substring(0,query.length - 1) +
     String.fromCharCode(query.codeUnitAt(query.length - 1) + 1)
      ).snapshots().map((event) {
       List<Community> communityList = [];
       for (var doc in event.docs) {
         communityList.add(Community.fromMap(doc.data() as Map<String, dynamic>));
       }
       return communityList;
      });
}

FutureVoid joinCommunity (String communityName, String userId)async{
try {
  return right(communities.doc(communityName).update({
    'members' : FieldValue.arrayUnion([userId])
  }));
}on FirebaseAuthException catch (e) {
 throw e.message!; 
} catch (e) {
  return left(Failure(e.toString()));
}
}

FutureVoid leaveCommunity (String communityName, String userId)async{
try {
  return right(communities.doc(communityName).update({
    'members' : FieldValue.arrayRemove([userId])
  }));
}on FirebaseAuthException catch (e) {
 throw e.message!; 
} catch (e) {
  return left(Failure(e.toString()));
}
}


FutureVoid addMods (String communityName, List<String> uids)async{
try {
  return right(communities.doc(communityName).update({
    'mods' : uids
  }));
}on FirebaseAuthException catch (e) {
 throw e.message!; 
} catch (e) {
  return left(Failure(e.toString()));
}
}

CollectionReference get communities => firebaseFirestore.collection('community');


}