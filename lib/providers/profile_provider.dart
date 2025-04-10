import 'package:flutter/material.dart';
import 'package:temp_app/models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  // Initialize profile with default data
  void initializeProfile() {
    _profile = UserProfile(
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+91 98765 43210',
      gender: 'Male',
      dateOfBirth: DateTime.now(),
    );
    notifyListeners();
  }

  // Update profile
  Future<void> updateProfile(UserProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to update profile
      // Simulating API delay
      await Future.delayed(const Duration(seconds: 1));

      _profile = updatedProfile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update profile image
  Future<void> updateProfileImage(String imageUrl) async {
    if (_profile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to update profile image
      // Simulating API delay
      await Future.delayed(const Duration(seconds: 1));

      _profile = _profile!.copyWith(profileImageUrl: imageUrl);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
