import 'package:flutter/material.dart';
import 'package:temp_app/models/user_profile.dart';
import '../services/firebase_service.dart';
import '../services/user_service.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;
  final _firebaseService = FirebaseService();
  final _userService = UserService();

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  // Initialize profile with Firebase data
  Future<void> initializeProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _firebaseService.currentUser?.uid;
      if (userId != null) {
        final user = await _userService.getUser(userId);
        if (user != null) {
          _profile = UserProfile(
            name: user.name,
            email: user.email,
            phone: user.phoneNumber,
            gender: user.gender ?? 'Not specified',
            dateOfBirth: user.dateOfBirth ?? DateTime.now(),
            address: user.address ?? '',
          );
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profile
  Future<void> updateProfile(UserProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _firebaseService.currentUser?.uid;
      if (userId != null) {
        await _userService.updateUserProfile(
          userId: userId,
          name: updatedProfile.name,
          email: updatedProfile.email,
          phoneNumber: updatedProfile.phone,
          address: updatedProfile.address,
          gender: updatedProfile.gender,
          dateOfBirth: updatedProfile.dateOfBirth,
        );
        _profile = updatedProfile;
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profile image
  Future<void> updateProfileImage(String imagePath) async {
    if (_profile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final userId = _firebaseService.currentUser?.uid;
      if (userId != null) {
        await _userService.updateUserProfile(
          userId: userId,
          imagePath: imagePath,
        );
      }
    } catch (e) {
      print('Error updating profile image: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
