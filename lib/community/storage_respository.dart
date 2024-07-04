import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/typedef.dart';

final StorageRepositoryProvider = Provider((ref) {
  return StorageRepository(firebaseStorage: FirebaseStorage.instance);
});

class StorageRepository {
  final FirebaseStorage firebaseStorage;

  StorageRepository({required this.firebaseStorage});

FutureEither<String> storeFile ({
  required String path,
  required String id,
  required File? file,

})async{
 try {
    final ref = firebaseStorage.ref().child(path).child(id);
  UploadTask uploadTask = ref.putFile(file!);
  final snapshot = await uploadTask;

  return right(await snapshot.ref.getDownloadURL());
 } catch (e) {
   return left(Failure(e.toString()));
 }
}

}