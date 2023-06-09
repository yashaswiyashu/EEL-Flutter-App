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
    apiKey: 'AIzaSyA0bVv1UUtjKACtDzc6yeWcZHh77r7UuM8',
    appId: '1:206468790018:web:983d51c2478cc62635f41b',
    messagingSenderId: '206468790018',
    projectId: 'energyefficientlightsproject',
    authDomain: 'energyefficientlightsproject.firebaseapp.com',
    storageBucket: 'energyefficientlightsproject.appspot.com',
    measurementId: 'G-44CVZ0HCND',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCHOxZA9r2NH_dKJdvh5hCerLHJzc36C4',
    appId: '1:206468790018:android:81cb78874774062b35f41b',
    messagingSenderId: '206468790018',
    projectId: 'energyefficientlightsproject',
    storageBucket: 'energyefficientlightsproject.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDNAW_NGUduhEcFnIdgo08Vkw0-lixPQw',
    appId: '1:206468790018:ios:0515313f5c97c25535f41b',
    messagingSenderId: '206468790018',
    projectId: 'energyefficientlightsproject',
    storageBucket: 'energyefficientlightsproject.appspot.com',
    iosClientId: '206468790018-mml1rtktmj8762ca2ges521i592gjg1b.apps.googleusercontent.com',
    iosBundleId: 'com.rscsys.energyEfficientLights',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDNAW_NGUduhEcFnIdgo08Vkw0-lixPQw',
    appId: '1:206468790018:ios:0515313f5c97c25535f41b',
    messagingSenderId: '206468790018',
    projectId: 'energyefficientlightsproject',
    storageBucket: 'energyefficientlightsproject.appspot.com',
    iosClientId: '206468790018-mml1rtktmj8762ca2ges521i592gjg1b.apps.googleusercontent.com',
    iosBundleId: 'com.rscsys.energyEfficientLights',
  );
}
