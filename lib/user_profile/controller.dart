
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/community/storage_respository.dart';
import 'package:reddit_clone/model/usermodel.dart';
import 'package:reddit_clone/user_profile/repository.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
      userProfileRepository: ref.watch(userProfileRepositoryProvider),
      ref: ref,
      storageRepository: ref.watch(StorageRepositoryProvider));
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository userProfileRepository;
  final Ref ref;
  final StorageRepository storageRepository;

  UserProfileController({
    required this.userProfileRepository,
    required this.ref,
    required this.storageRepository,
  }) : super(false);

  

  void editProfile(
      {

      required BuildContext context,
      required File? profileFile,
      required File? bannerFile,
      required String name
      }) async {
        state = true;

        UserModel user = ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await storageRepository.storeFile(
          path: 'users/profile', id: user.uid, file: profileFile);
      res.fold(
          (l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))),
          (r) => user = user.copyWith(profilePic: r));
    }
    if (bannerFile != null) {
      final res = await storageRepository.storeFile(
          path: 'users/banner', id: user.uid, file:bannerFile);
      res.fold(
          (l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))),
          (r) => user = user.copyWith(banner:  r));
    }

    user = user.copyWith(name: name);

  final res = await  userProfileRepository.editProfile(user);
  state = false;
  res.fold((l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))), (r) {
                ref.read(userProvider.notifier).update((state) => user);
                Routemaster.of(context).pop(); 
              } );
 
  }

 

}