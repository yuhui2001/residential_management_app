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
    apiKey: 'AIzaSyBsROg9zrk8OKqaHkB8HbSripq1-qiSQ7Y',
    appId: '1:409660395028:web:4617487c1670300be46101',
    messagingSenderId: '409660395028',
    projectId: 'residentialmanagingapp',
    authDomain: 'residentialmanagingapp.firebaseapp.com',
    databaseURL:
        'https://residentialmanagingapp-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'residentialmanagingapp.appspot.com',
    measurementId: 'G-035SZJ1X5V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzf0k4KgDRPVPFFtjoQ5kNXgoPMH8SIHg',
    appId: '1:409660395028:android:b6b98e55aa354a85e46101',
    messagingSenderId: '409660395028',
    projectId: 'residentialmanagingapp',
    databaseURL:
        'https://residentialmanagingapp-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'residentialmanagingapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfsZpPAId9mdov74KCT__9eWvcyMAKwKc',
    appId: '1:409660395028:ios:22fe21310d0edd99e46101',
    messagingSenderId: '409660395028',
    projectId: 'residentialmanagingapp',
    databaseURL:
        'https://residentialmanagingapp-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'residentialmanagingapp.appspot.com',
    iosBundleId: 'com.example.residentialManagementApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfsZpPAId9mdov74KCT__9eWvcyMAKwKc',
    appId: '1:409660395028:ios:5358c10a3854c8a2e46101',
    messagingSenderId: '409660395028',
    projectId: 'residentialmanagingapp',
    databaseURL:
        'https://residentialmanagingapp-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'residentialmanagingapp.appspot.com',
    iosBundleId: 'com.example.residentialManagementApp.RunnerTests',
  );
}
