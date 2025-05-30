import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? address;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastUpdated;
  final int points;
  final int itemsRecycled;
  final int itemsSold;
  final int itemsDonated;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.address,
    this.gender,
    this.dateOfBirth,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.lastUpdated,
    required this.points,
    required this.itemsRecycled,
    required this.itemsSold,
    required this.itemsDonated,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'points': points,
      'itemsRecycled': itemsRecycled,
      'itemsSold': itemsSold,
      'itemsDonated': itemsDonated,
    };
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'],
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'] != null
          ? (data['dateOfBirth'] as Timestamp).toDate()
          : null,
      profileImageUrl: data['profileImageUrl'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
      points: data['points'] ?? 0,
      itemsRecycled: data['itemsRecycled'] ?? 0,
      itemsSold: data['itemsSold'] ?? 0,
      itemsDonated: data['itemsDonated'] ?? 0,
    );
  }
}
