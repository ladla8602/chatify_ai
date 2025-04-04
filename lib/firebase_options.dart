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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBGNCoFbJ0bZhFQw9UzfcVYOQv9ADs7iIo',
    appId: '1:1047757805269:web:66cfa56c1c82e20416745c',
    messagingSenderId: '1047757805269',
    projectId: 'chatifyai-7a694',
    authDomain: 'chatifyai-7a694.firebaseapp.com',
    storageBucket: 'chatifyai-7a694.firebasestorage.app',
    measurementId: 'G-RN303QE2GB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJwoS6GArUAyDU2AElmuo5shGDbVtUymQ',
    appId: '1:1047757805269:android:f293bc706d0baa3116745c',
    messagingSenderId: '1047757805269',
    projectId: 'chatifyai-7a694',
    storageBucket: 'chatifyai-7a694.firebasestorage.app',
  );

}