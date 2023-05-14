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
    apiKey: 'AIzaSyBG1zqQRrBvMcKO9xf5h7WpQnw3-WLa-7Q',
    appId: '1:104022790962:web:bd35e9991b7159bce63d2b',
    messagingSenderId: '104022790962',
    projectId: 'swifttracklocal',
    authDomain: 'swifttracklocal.firebaseapp.com',
    storageBucket: 'swifttracklocal.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8n5nHahU0rFP5y7UuHnMN5lK2Qtsr5Vs',
    appId: '1:104022790962:android:7e6fde522dde74f6e63d2b',
    messagingSenderId: '104022790962',
    projectId: 'swifttracklocal',
    storageBucket: 'swifttracklocal.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqjNTVr3DLTh6tWVJ8YUXQnYqs0UVaXKQ',
    appId: '1:104022790962:ios:c00b4ec25e3c0163e63d2b',
    messagingSenderId: '104022790962',
    projectId: 'swifttracklocal',
    storageBucket: 'swifttracklocal.appspot.com',
    iosClientId: '104022790962-a0s3ag0a5v96soo8i0ud37mj94t1m83r.apps.googleusercontent.com',
    iosBundleId: 'com.example.swifttrack',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqjNTVr3DLTh6tWVJ8YUXQnYqs0UVaXKQ',
    appId: '1:104022790962:ios:c00b4ec25e3c0163e63d2b',
    messagingSenderId: '104022790962',
    projectId: 'swifttracklocal',
    storageBucket: 'swifttracklocal.appspot.com',
    iosClientId: '104022790962-a0s3ag0a5v96soo8i0ud37mj94t1m83r.apps.googleusercontent.com',
    iosBundleId: 'com.example.swifttrack',
  );
}
