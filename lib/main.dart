import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
  import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/auth/auth_controller.dart';
import 'package:reddit_clone/error_screen.dart';
import 'package:reddit_clone/loader.dart';
import 'package:reddit_clone/model/usermodel.dart';

import 'package:reddit_clone/router.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';
void main()async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(ProviderScope(child: const MyApp()));
}



class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
UserModel? userModel;
  void getData (WidgetRef ref, User data)async{
 userModel = await ref.watch(authControllerProvider.notifier).getUserDataFromFirebase(data.uid).first;
 ref.read(userProvider.notifier).update((state) => userModel);
 setState(() {
   
 });
  }

  @override
  Widget build(BuildContext context) {
    return  ref.watch(authStateChangeProvider).when(data:(data) => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        if (data != null) {
          getData(ref, data);
          if (userModel != null) {
            return loggedInRoute;
          }
        }
        return loggedOutRoute;
      }),
        routeInformationParser: RoutemasterParser(),

      theme: ThemeData.dark(),
      
    ), error:(error, stackTrace) => ErrorScreen(error: error.toString()), loading: () => Loader(),);
  }
}

