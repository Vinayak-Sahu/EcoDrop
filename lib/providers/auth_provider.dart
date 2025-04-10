import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseService.currentUser != null;

  // Initialize auth state
  void init() {
    _firebaseService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        await _loadUserProfile(firebaseUser.uid);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  // Load user profile
  Future<void> _loadUserProfile(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _firebaseService.getUserProfile(uid);
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _firebaseService.signInWithEmailAndPassword(
        email,
        password,
      );
      await _loadUserProfile(userCredential.user!.uid);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<void> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential =
          await _firebaseService.registerWithEmailAndPassword(
        email,
        password,
      );

      // Create user profile
      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        phoneNumber: '',
        address: '',
        points: 0,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      await _firebaseService.createOrUpdateUserProfile(user);
      _user = user;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseService.signOut();
      _user = null;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
  }) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = _user!.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
      );

      await _firebaseService.createOrUpdateUserProfile(updatedUser);
      _user = updatedUser;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
