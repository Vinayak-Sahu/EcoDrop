import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../models/activity_model.dart';

class ActivityProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<ActivityModel> _activities = [];
  bool _isLoading = false;
  String? _error;

  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load user activities
  Future<void> loadUserActivities(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _firebaseService.getUserActivities(userId).listen(
        (activities) {
          _activities = activities;
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add activity
  Future<void> addActivity(ActivityModel activity) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firebaseService.addActivity(activity);
      _activities.insert(0, activity);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get total points
  Future<int> getTotalPoints(String userId) async {
    try {
      return await _firebaseService.getUserTotalPoints(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
