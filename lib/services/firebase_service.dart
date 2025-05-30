import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../models/activity_model.dart';
import 'dart:io';
import 'dart:async';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Get current user
  User? get currentUser => auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  // Create or update user profile
  Future<void> createOrUpdateUserProfile(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.uid).set(
            user.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Add activity
  Future<void> addActivity(ActivityModel activity) async {
    try {
      // Add activity to activities collection
      await firestore.collection('activities').add(activity.toMap());

      // Update user points
      await firestore.collection('users').doc(activity.userId).update({
        'points': FieldValue.increment(activity.points),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get user activities
  Stream<List<ActivityModel>> getUserActivities(String userId) {
    return firestore
        .collection('activities')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ActivityModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get user total points
  Future<int> getUserTotalPoints(String userId) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['points'] ?? 0;
      }
      return 0;
    } catch (e) {
      rethrow;
    }
  }

  // Store image locally and upload to Firebase in background
  Future<String?> storeAndUploadImage(String imagePath, String userId) async {
    try {
      // Get local application directory
      final appDir = await getTemporaryDirectory();
      final localImagesDir = Directory('${appDir.path}/images');

      // Create images directory if it doesn't exist
      if (!await localImagesDir.exists()) {
        await localImagesDir.create(recursive: true);
      }

      // Create a unique filename for the image
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String localPath = '${localImagesDir.path}/$fileName';

      // Copy the image to local storage
      final File originalFile = File(imagePath);
      final File localFile = await originalFile.copy(localPath);

      // Start background upload
      _uploadToFirebaseInBackground(localFile, userId, fileName);

      // Return local path immediately
      return localPath;
    } catch (e) {
      print('Error storing image locally: $e');
      if (e is MissingPluginException) {
        print(
            'Path provider plugin not initialized. Please ensure path_provider is properly set up in your pubspec.yaml');
      }
      return null;
    }
  }

  // Background upload to Firebase
  Future<void> _uploadToFirebaseInBackground(
      File localFile, String userId, String fileName) async {
    try {
      final String path = 'profile_images/$userId/$fileName';
      final storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref(path);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': localFile.path},
      );

      final UploadTask uploadTask = storageRef.putFile(
        localFile,
        metadata,
      );

      // Wait for the upload to complete
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      print('Background upload successful. URL: $downloadUrl');

      // Update user profile with the new image URL
      if (currentUser != null) {
        await firestore.collection('users').doc(currentUser!.uid).update({
          'profileImageUrl': downloadUrl,
        });
      }
    } catch (e) {
      print('Error in background upload: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
    }
  }

  // Get local image path
  Future<String?> getLocalImagePath(String userId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final localImagesDir = Directory('${appDir.path}/images');

      if (!await localImagesDir.exists()) {
        return null;
      }

      // Get the most recent image for the user
      final files = await localImagesDir.list().toList();
      if (files.isEmpty) {
        return null;
      }

      // Sort files by modification time (newest first)
      files.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      return files.first.path;
    } catch (e) {
      print('Error getting local image path: $e');
      return null;
    }
  }
}
