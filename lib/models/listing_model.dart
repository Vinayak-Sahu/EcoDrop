import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String type; // 'sell', 'donate', or 'recycle'
  final String category;
  final String? imageUrl;
  final double? price; // Only for sell listings
  final bool? isNegotiable; // Only for sell listings
  final String? itemCondition; // Condition of the item
  final String? itemWeight; // Weight for recycling items
  final String? recyclingCenterId; // For recycling listings
  final String? ngoId; // For donation listings
  final String status; // 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? scheduledPickupDate; // Scheduled pickup date and time
  final String? pickupNotes; // Additional notes for pickup

  Listing({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    this.imageUrl,
    this.price,
    this.isNegotiable,
    this.itemCondition,
    this.itemWeight,
    this.recyclingCenterId,
    this.ngoId,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.scheduledPickupDate,
    this.pickupNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'isNegotiable': isNegotiable,
      'itemCondition': itemCondition,
      'itemWeight': itemWeight,
      'recyclingCenterId': recyclingCenterId,
      'ngoId': ngoId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'scheduledPickupDate': scheduledPickupDate != null
          ? Timestamp.fromDate(scheduledPickupDate!)
          : null,
      'pickupNotes': pickupNotes,
    };
  }

  factory Listing.fromMap(Map<String, dynamic> map) {
    return Listing(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'],
      price: map['price']?.toDouble(),
      isNegotiable: map['isNegotiable'],
      itemCondition: map['itemCondition'],
      itemWeight: map['itemWeight'],
      recyclingCenterId: map['recyclingCenterId'],
      ngoId: map['ngoId'],
      status: map['status'] ?? 'active',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
      scheduledPickupDate: map['scheduledPickupDate'] != null
          ? (map['scheduledPickupDate'] as Timestamp).toDate()
          : null,
      pickupNotes: map['pickupNotes'],
    );
  }

  Listing copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? type,
    String? category,
    String? imageUrl,
    double? price,
    bool? isNegotiable,
    String? itemCondition,
    String? itemWeight,
    String? recyclingCenterId,
    String? ngoId,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? scheduledPickupDate,
    String? pickupNotes,
  }) {
    return Listing(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      itemCondition: itemCondition ?? this.itemCondition,
      itemWeight: itemWeight ?? this.itemWeight,
      recyclingCenterId: recyclingCenterId ?? this.recyclingCenterId,
      ngoId: ngoId ?? this.ngoId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      scheduledPickupDate: scheduledPickupDate ?? this.scheduledPickupDate,
      pickupNotes: pickupNotes ?? this.pickupNotes,
    );
  }
}
