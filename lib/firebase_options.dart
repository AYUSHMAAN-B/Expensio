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
    apiKey: 'AIzaSyCZTQq4qhfrfLWsjDcq0JQ3e_xLNxHg2yQ',
    appId: '1:1042485160119:web:bea4a804b562f8a4520532',
    messagingSenderId: '1042485160119',
    projectId: 'expensio-41096',
    authDomain: 'expensio-41096.firebaseapp.com',
    storageBucket: 'expensio-41096.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5F3Y_BWdWTf4MIr9v5s9kTp8-d1nFVMg',
    appId: '1:1042485160119:android:873ed44ac57575c3520532',
    messagingSenderId: '1042485160119',
    projectId: 'expensio-41096',
    storageBucket: 'expensio-41096.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4QwULrHdTMXrPCI78xV03HYaybsuGxSc',
    appId: '1:1042485160119:ios:1dbae8886547e4ea520532',
    messagingSenderId: '1042485160119',
    projectId: 'expensio-41096',
    storageBucket: 'expensio-41096.firebasestorage.app',
    iosClientId: '1042485160119-bjl2mllbek26o2sqap111i60ffn11h6g.apps.googleusercontent.com',
    iosBundleId: 'com.example.expenseTracker',
  );
}
