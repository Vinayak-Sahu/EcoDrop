import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferences {
  final bool emailNotifications;
  final bool locationEnabled;
  final DateTime lastUpdated;

  UserPreferences({
    required this.emailNotifications,
    required this.locationEnabled,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'emailNotifications': emailNotifications,
      'locationEnabled': locationEnabled,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      emailNotifications: map['emailNotifications'] ?? true,
      locationEnabled: map['locationEnabled'] ?? true,
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  UserPreferences copyWith({
    bool? emailNotifications,
    bool? locationEnabled,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
