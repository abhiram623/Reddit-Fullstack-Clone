import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/typedef.dart';
import 'package:reddit_clone/model/usermodel.dart';
final authRepositoryProvider = Provider((ref) {
  return AuthRepository(auth: FirebaseAuth.instance, firebaseFirestore: FirebaseFirestore.instance, googleSignIn: GoogleSignIn());
});

class AuthRepository {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firebaseFirestore;

  AuthRepository( {required this.auth, required this.firebaseFirestore,required this.googleSignIn,});




  FutureEither<UserModel>  signinWithGoogle ()async{
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential

 
  
  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
late UserModel user;

  if (userCredential.additionalUserInfo!.isNewUser) {
      user = UserModel(name: userCredential.user!.displayName  ?? 'No name', email: userCredential.user!.email ?? 'No email', profilePic: userCredential.user!.photoURL ??Constants.avatarDefault , uid: userCredential.user!.uid, banner: Constants.bannerDefault, isAuthenticated: true, dateTime: DateTime.now(),awards: [],karma: 0);
  await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).set(user.toMap());
  }else{
    user = await getUserDataFromFirebase(userCredential.user!.uid).first;
  }
  print(userCredential.user!.email);
 return right(user);
    
    
    } on FirebaseException catch(e){
      throw e.message!;
    } catch (e) {
     return left(Failure(e.toString()));
    }
  }
  
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Stream <UserModel> getUserDataFromFirebase (String uid){
    return firebaseFirestore.collection('users').doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String,dynamic>));
  }

  void logOut ()async{
await googleSignIn.signOut();
await auth.signOut();
  }
}