import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
    appId: '1:88796048204:android:af71f7d6670f78e86e7de9',
    messagingSenderId: '88796048204',
    projectId: 'ecodrop-404ac',
    storageBucket: 'ecodrop-404ac.firebasestorage.app',
  );

  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
    appId: '1:88796048204:ios:af71f7d6670f78e86e7de9',
    messagingSenderId: '88796048204',
    projectId: 'ecodrop-404ac',
    storageBucket: 'ecodrop-404ac.firebasestorage.app',
    iosClientId: 'com.example.ecoDrop',
    iosBundleId: 'com.example.ecoDrop',
  );

  static final FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
    appId: '1:88796048204:macos:af71f7d6670f78e86e7de9',
    messagingSenderId: '88796048204',
    projectId: 'ecodrop-404ac',
    storageBucket: 'ecodrop-404ac.firebasestorage.app',
    iosClientId: 'com.example.ecoDrop',
    iosBundleId: 'com.example.ecoDrop',
  );

  static final FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
    appId: '1:88796048204:windows:af71f7d6670f78e86e7de9',
    messagingSenderId: '88796048204',
    projectId: 'ecodrop-404ac',
    storageBucket: 'ecodrop-404ac.firebasestorage.app',
  );

  static final FirebaseOptions linux = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
    appId: '1:88796048204:linux:af71f7d6670f78e86e7de9',
    messagingSenderId: '88796048204',
    projectId: 'ecodrop-404ac',
    storageBucket: 'ecodrop-404ac.firebasestorage.app',
  );
}
