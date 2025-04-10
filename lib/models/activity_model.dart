import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivityType { recycling, donation, selling, order }

class ActivityModel {
  final String id;
  final String userId;
  final ActivityType type;
  final int points;
  final String description;
  final DateTime date;
  final Map<String, dynamic>? details;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.points,
    required this.description,
    required this.date,
    this.details,
  });

  // Convert ActivityModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type.toString().split('.').last,
      'points': points,
      'description': description,
      'date': Timestamp.fromDate(date),
      'details': details,
    };
  }

  // Create ActivityModel from Firestore Document
  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: ActivityType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => ActivityType.recycling,
      ),
      points: data['points'] ?? 0,
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      details: data['details'],
    );
  }
}
