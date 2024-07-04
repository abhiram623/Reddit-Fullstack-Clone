import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/community/community_model.dart';
import 'package:reddit_clone/community/repository.dart';
import 'package:reddit_clone/community/storage_respository.dart';
import 'package:reddit_clone/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/show_snackbar.dart';
import 'package:routemaster/routemaster.dart';

final searchCommunityProvider = StreamProvider.family((ref,String query)  {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final userCommunitiesProvider = StreamProvider((ref) {
  return ref.watch(communityControllerProvider.notifier).getUserCommunities();
});
final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      communtiyRepository: ref.watch(communityRepositoryProvider),
      ref: ref,
      storageRepository: ref.watch(StorageRepositoryProvider));
});

class CommunityController extends StateNotifier<bool> {
  final CommuntiyRepository communtiyRepository;
  final Ref ref;
  final StorageRepository storageRepository;

  CommunityController({
    required this.communtiyRepository,
    required this.ref,
    required this.storageRepository,
  }) : super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
// var id = Uuid().v1();
    final uid = ref.read(userProvider)?.uid ?? '';
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);

    final res = await communtiyRepository.createCommunity(community);
    state = false;
    res.fold(
        (l) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.message))), (r) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Community created sucessfully")));
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = ref.read(userProvider)!.uid;

    return communtiyRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return communtiyRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required Community community,
      required BuildContext context,
      required File? profileFile,
      required File? bannerFile}) async {
        state = true;
    if (profileFile != null) {
      final res = await storageRepository.storeFile(
          path: 'communities/profile', id: community.name, file: profileFile);
      res.fold(
          (l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))),
          (r) => community = community.copyWith(avatar: r));
    }
    if (bannerFile != null) {
      final res = await storageRepository.storeFile(
          path: 'communities/banner', id: community.name, file:bannerFile);
      res.fold(
          (l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))),
          (r) => community = community.copyWith(banner:  r));
    }

  final res = await  communtiyRepository.editCommunity(community);
  state = false;
  res.fold((l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))), (r) => Routemaster.of(context).pop()); 
 
  }

  Stream < List<Community>> searchCommunity (String query){
    return communtiyRepository.searchCommunity(query);
  }

  void joinCommunity (Community community,BuildContext context)async{
final user = ref.read(userProvider)!;

Either<Failure, void> res;
   if (community.members.contains(user.uid)) {
   res = await communtiyRepository.leaveCommunity(community.name, user.uid);
   }else{
    res = await communtiyRepository.joinCommunity(community.name, user.uid);
   }

   res.fold((l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))), (r) {
              if (community.members.contains(user.uid)) {
                showSnackBar(context, 'Community left sucessfully');
                
              }else{
                showSnackBar(context, 'Community Join sucessfully');
              }
              });

  }

  void addMods (String communityName, List<String> uids,BuildContext context)async{
   final res =await communtiyRepository.addMods(communityName, uids);

   res.fold((l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))), (r) => Routemaster.of(context).pop());
  }

}
