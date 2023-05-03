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
    apiKey: 'AIzaSyDIcjiWWn0F5k62MgB_fd5z-Fdn36MVEao',
    appId: '1:552149597115:web:aa3b8cab004a0ddaaea29e',
    messagingSenderId: '552149597115',
    projectId: 'flutter-assignment-ebutler',
    authDomain: 'flutter-assignment-ebutler.firebaseapp.com',
    storageBucket: 'flutter-assignment-ebutler.appspot.com',
    measurementId: 'G-PJEEDLYG71',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-M_PCX6je_msNHci3QO4W2-fgIFjbIrk',
    appId: '1:552149597115:android:ed55a2ad11d17b78aea29e',
    messagingSenderId: '552149597115',
    projectId: 'flutter-assignment-ebutler',
    storageBucket: 'flutter-assignment-ebutler.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChQHxWMCqIe1u1eOVzuWK6JCFK_VR8O7I',
    appId: '1:552149597115:ios:0fcbf0ca77b50580aea29e',
    messagingSenderId: '552149597115',
    projectId: 'flutter-assignment-ebutler',
    storageBucket: 'flutter-assignment-ebutler.appspot.com',
    iosClientId: '552149597115-cgci2mh5qlrhi14crphkq9n87qh21nko.apps.googleusercontent.com',
    iosBundleId: 'com.assignment.ebutler',
  );
}
