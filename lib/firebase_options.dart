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
    apiKey: 'AIzaSyBLWZ0waPuUdDK5tN6UQ19659IO5RDoRGw',
    appId: '1:437881507377:web:c6a9433e937a9a77574f10',
    messagingSenderId: '437881507377',
    projectId: 'touriso-ea0',
    authDomain: 'touriso-ea0.firebaseapp.com',
    storageBucket: 'touriso-ea0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrrSkkxjA2EbV2dzXpxUp8aoIy9e6oaDY',
    appId: '1:437881507377:android:cb3f4229415f13bd574f10',
    messagingSenderId: '437881507377',
    projectId: 'touriso-ea0',
    storageBucket: 'touriso-ea0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZMMwvbAFaUYzz95AInWEnWdR66t5LeV8',
    appId: '1:437881507377:ios:d5e30b1fce190930574f10',
    messagingSenderId: '437881507377',
    projectId: 'touriso-ea0',
    storageBucket: 'touriso-ea0.appspot.com',
    iosClientId: '437881507377-7neuval0ftdim7rktk7v12n1ijr7ds2v.apps.googleusercontent.com',
    iosBundleId: 'com.example.touriso',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZMMwvbAFaUYzz95AInWEnWdR66t5LeV8',
    appId: '1:437881507377:ios:71087585d5ff680a574f10',
    messagingSenderId: '437881507377',
    projectId: 'touriso-ea0',
    storageBucket: 'touriso-ea0.appspot.com',
    iosClientId: '437881507377-4ltnnchtbbrfr6ilu09iglo1770l3f4o.apps.googleusercontent.com',
    iosBundleId: 'com.example.touriso.RunnerTests',
  );
}