// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCHIM2XEQW-A-wnB5IHryTdZIAktDe3K1w',
    appId: '1:42728574757:web:ebd80e21300fa5753ed4cc',
    messagingSenderId: '42728574757',
    projectId: 'prac-app-8fee3',
    authDomain: 'prac-app-8fee3.firebaseapp.com',
    storageBucket: 'prac-app-8fee3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbpFQhc95RY2y8wggSYrJPuPKI8Mbjtn4',
    appId: '1:42728574757:android:0a780b5a3720fba93ed4cc',
    messagingSenderId: '42728574757',
    projectId: 'prac-app-8fee3',
    storageBucket: 'prac-app-8fee3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmJ__MSbBFA9ZJlB_PKt8kzSM1CojU9KI',
    appId: '1:42728574757:ios:3a3721afa3a9d1bb3ed4cc',
    messagingSenderId: '42728574757',
    projectId: 'prac-app-8fee3',
    storageBucket: 'prac-app-8fee3.appspot.com',
    androidClientId: '42728574757-v0hfm5jgm2vmrjhvpqoadu3g7q3a080c.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmJ__MSbBFA9ZJlB_PKt8kzSM1CojU9KI',
    appId: '1:42728574757:ios:3a3721afa3a9d1bb3ed4cc',
    messagingSenderId: '42728574757',
    projectId: 'prac-app-8fee3',
    storageBucket: 'prac-app-8fee3.appspot.com',
    androidClientId: '42728574757-v0hfm5jgm2vmrjhvpqoadu3g7q3a080c.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditClone',
  );
}
