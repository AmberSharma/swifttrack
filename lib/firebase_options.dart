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
        return android;
      // throw UnsupportedError(
      //   'DefaultFirebaseOptions have not been configured for windows - '
      //   'you can reconfigure this by running the FlutterFire CLI again.',
      // );
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
    apiKey: 'AIzaSyD7jglBnDtvhpN_4npa_lo2cfftJfHvaNU',
    appId: '1:106652086885:web:530126f36936206eb90c8c',
    messagingSenderId: '106652086885',
    projectId: 'swifttrack-dam-27fda',
    authDomain: 'swifttrack-dam-27fda.firebaseapp.com',
    storageBucket: 'swifttrack-dam-27fda.appspot.com',
    measurementId: 'G-1XG9JSQSFD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKvQ_o0l0tRs-Go60eGijm54nCqBYsYsA',
    appId: '1:106652086885:android:d433a1e75f738505b90c8c',
    messagingSenderId: '106652086885',
    projectId: 'swifttrack-dam-27fda',
    storageBucket: 'swifttrack-dam-27fda.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDo4joesz2t8luJMm7gy320E0emhLk8yhI',
    appId: '1:106652086885:ios:7dbbd86b1fd0a30db90c8c',
    messagingSenderId: '106652086885',
    projectId: 'swifttrack-dam-27fda',
    storageBucket: 'swifttrack-dam-27fda.appspot.com',
    iosClientId:
        '106652086885-6qs5q0n2mgqucnp9o0v865dsfmitj6ll.apps.googleusercontent.com',
    iosBundleId: 'com.example.swifttrack',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDo4joesz2t8luJMm7gy320E0emhLk8yhI',
    appId: '1:106652086885:ios:7dbbd86b1fd0a30db90c8c',
    messagingSenderId: '106652086885',
    projectId: 'swifttrack-dam-27fda',
    storageBucket: 'swifttrack-dam-27fda.appspot.com',
    iosClientId:
        '106652086885-6qs5q0n2mgqucnp9o0v865dsfmitj6ll.apps.googleusercontent.com',
    iosBundleId: 'com.example.swifttrack',
  );
}
