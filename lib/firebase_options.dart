// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyDkr_GgPCU2JAbxkpoKgPb-FRWVJEjelg4',
    appId: '1:952844103852:web:e205933c54e96042edaf09',
    messagingSenderId: '952844103852',
    projectId: 'sba7-ed3fd',
    authDomain: 'sba7-ed3fd.firebaseapp.com',
    storageBucket: 'sba7-ed3fd.appspot.com',
    measurementId: 'G-RTJKFMPH89',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxW3oce-dEYk-xne2-0i4KvpNF_8gTqQE',
    appId: '1:952844103852:android:bbda5fdadcfbe299edaf09',
    messagingSenderId: '952844103852',
    projectId: 'sba7-ed3fd',
    storageBucket: 'sba7-ed3fd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbg_t-_UIHnF-CO3e-r-FZnfY-e1cH55Y',
    appId: '1:952844103852:ios:7f5a0a137076f8f7edaf09',
    messagingSenderId: '952844103852',
    projectId: 'sba7-ed3fd',
    storageBucket: 'sba7-ed3fd.appspot.com',
    iosClientId: '952844103852-bq8on6fi4sda5t73srcf4qokeib66kkv.apps.googleusercontent.com',
    iosBundleId: 'com.example.sba7',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbg_t-_UIHnF-CO3e-r-FZnfY-e1cH55Y',
    appId: '1:952844103852:ios:7f5a0a137076f8f7edaf09',
    messagingSenderId: '952844103852',
    projectId: 'sba7-ed3fd',
    storageBucket: 'sba7-ed3fd.appspot.com',
    iosClientId: '952844103852-bq8on6fi4sda5t73srcf4qokeib66kkv.apps.googleusercontent.com',
    iosBundleId: 'com.example.sba7',
  );
}
