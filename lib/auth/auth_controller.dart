

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_repository.dart';
import 'package:reddit_clone/model/usermodel.dart';


final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});


final authControllerProvider = StateNotifierProvider<AuthController,bool>((ref) {
  return AuthController(authRepository: ref.watch(authRepositoryProvider), ref: ref);
});

final authStateChangeProvider  = StreamProvider((ref)  {
  return ref.watch(authControllerProvider.notifier).authStateChanges;
});
final getUserDataFromFirebaseProvider  = StreamProvider.family((ref,String uid)  {
  return ref.watch(authControllerProvider.notifier).getUserDataFromFirebase(uid);
});

class AuthController extends  StateNotifier<bool>{
  final AuthRepository authRepository;
  final Ref ref;

  AuthController( {required this.authRepository,required this.ref,}) : super(false);

  Stream<User?> get authStateChanges => authRepository.authStateChanges;

  Stream <UserModel> getUserDataFromFirebase (String uid){
return authRepository.getUserDataFromFirebase(uid);
  }
  
  void signinWithGoogle (BuildContext context)async{
    state = true;
  final user = await authRepository.signinWithGoogle();
  state = false;
  user.fold((l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))), (userModel) => ref.read(userProvider.notifier).update((state) => userModel));
  }
void logOut ()async{
  authRepository.logOut();
}

}