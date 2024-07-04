import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/loader.dart';

class SignIn extends ConsumerWidget {
  const SignIn({super.key});

  void signinWithGoogle(WidgetRef ref,BuildContext context) {
    ref.read(authControllerProvider.notifier).signinWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isloading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                
              },
              child: Text('skip'))
        ],
        title: Padding(
          padding: const EdgeInsets.all(0),
          child: Image(
              width: 100,
              height: 40,
              image: AssetImage('assets/images/logo.png')),
        ),
      ),
      body: isloading ?  Loader() : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
              child: Text(
            "Dive into anything",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
          SizedBox(height: 40,),
          Container(height: 400,width: double.infinity,
          child: Image(image: AssetImage('assets/images/loginEmote.png')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              onPressed: (){
                signinWithGoogle(ref,context);
              }, child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Image(
                  height: 40,
                  image: AssetImage('assets/images/google.png')),
                  Text("Continue with Google")
                          ],),
              )),
          )
        ],
      ),
    );
  }
}
