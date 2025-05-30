import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'firebase_service.dart';
import '../models/user_stats.dart';
import '../models/user_preferences.dart';
import '../models/listing_model.dart';

class UserService {
  final String _collection = 'users';
  final _firebaseService = FirebaseService();

  Future<User> createUser({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final now = DateTime.now();
    final user = User(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      address: '',
      gender: 'Male',
      dateOfBirth: null,
      profileImageUrl: null,
      createdAt: now,
      updatedAt: now,
      lastUpdated: now,
      points: 0,
      itemsRecycled: 0,
      itemsSold: 0,
      itemsDonated: 0,
    );

    await _firebaseService.firestore.collection(_collection).doc(id).set({
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': '',
      'gender': 'Male',
      'dateOfBirth': null,
      'profileImageUrl': null,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
      'lastUpdated': Timestamp.fromDate(now),
      'points': 0,
      'itemsRecycled': 0,
      'itemsSold': 0,
      'itemsDonated': 0,
    });
    return user;
  }

  Future<User?> getUser(String userId) async {
    final doc = await _firebaseService.firestore
        .collection(_collection)
        .doc(userId)
        .get();
    if (!doc.exists) return null;
    return User.fromFirestore(doc);
  }

  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? gender,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    String? imagePath,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (address != null) updateData['address'] = address;
      if (gender != null) updateData['gender'] = gender;
      if (dateOfBirth != null) {
        updateData['dateOfBirth'] = Timestamp.fromDate(dateOfBirth);
      }
      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      // If imagePath is provided, upload the image first
      if (imagePath != null) {
        // Store image locally and start background upload
        final localImagePath =
            await _firebaseService.storeAndUploadImage(imagePath, userId);

        if (localImagePath != null) {
          // The background upload will update the profileImageUrl in Firestore
          // when the upload is complete
          print('Image stored locally at: $localImagePath');
        } else {
          throw Exception('Failed to store image locally');
        }
      }

      // Update user document in Firestore
      await _firebaseService.firestore
          .collection(_collection)
          .doc(userId)
          .update(updateData);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    final now = DateTime.now();
    data['updatedAt'] = Timestamp.fromDate(now);
    data['lastUpdated'] = Timestamp.fromDate(now);
    await _firebaseService.firestore
        .collection(_collection)
        .doc(userId)
        .update(data);
  }

  Future<void> updateUserProfileImage(String userId, String imagePath) async {
    try {
      // Store image locally and start background upload
      final localImagePath =
          await _firebaseService.storeAndUploadImage(imagePath, userId);

      if (localImagePath != null) {
        // The background upload will update the profileImageUrl in Firestore
        // when the upload is complete
        print('Image stored locally at: $localImagePath');
      } else {
        throw Exception('Failed to store image locally');
      }
    } catch (e) {
      print('Error updating user profile image: $e');
      rethrow;
    }
  }

  Future<void> incrementPoints(String userId, int points) async {
    final now = DateTime.now();
    await _firebaseService.firestore
        .collection(_collection)
        .doc(userId)
        .update({
      'points': FieldValue.increment(points),
      'updatedAt': Timestamp.fromDate(now),
      'lastUpdated': Timestamp.fromDate(now),
    });
  }

  Future<void> incrementItemsRecycled(String userId) async {
    final now = DateTime.now();
    await _firebaseService.firestore
        .collection(_collection)
        .doc(userId)
        .update({
      'itemsRecycled': FieldValue.increment(1),
      'updatedAt': Timestamp.fromDate(now),
      'lastUpdated': Timestamp.fromDate(now),
    });
  }

  Future<void> incrementItemsSold(String userId) async {
    final now = DateTime.now();
    await _firebaseService.firestore
        .collection(_collection)
        .doc(userId)
        .update({
      'itemsSold': FieldValue.increment(1),
      'updatedAt': Timestamp.fromDate(now),
      'lastUpdated': Timestamp.fromDate(now),
    });
  }

  Future<void> incrementItemsDonated(String userId) async {
    final now = DateTime.now();
    await _firebaseService.firestore
        .collection(_collection)
        .doc(userId)
        .update({
      'itemsDonated': FieldValue.increment(1),
      'updatedAt': Timestamp.fromDate(now),
      'lastUpdated': Timestamp.fromDate(now),
    });
  }

  // Create initial stats for new user
  Future<void> createInitialStats(String userId) async {
    final stats = UserStats(
      totalPoints: 0,
      itemsRecycled: 0,
      itemsSold: 0,
      itemsDonated: 0,
      recentActivities: [],
      availableRewards: [
        {
          'title': '₹1000 Amazon Voucher',
          'description': 'Get a ₹1000 voucher to use on Amazon',
          'points': 2000,
          'type': 'voucher',
          'validUntil': Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 30)),
          ),
        },
        {
          'title': 'Plant a Tree',
          'description': 'We will plant a tree in your name',
          'points': 1000,
          'type': 'environment',
          'validUntil': Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 30)),
          ),
        },
        {
          'title': 'Eco-Friendly Water Bottle',
          'description': 'Get a reusable water bottle',
          'points': 1500,
          'type': 'product',
          'validUntil': Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 30)),
          ),
        },
        {
          'title': '₹500 Flipkart Voucher',
          'description': 'Get a ₹500 voucher to use on Flipkart',
          'points': 1000,
          'type': 'voucher',
          'validUntil': Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 30)),
          ),
        },
      ],
    );

    await _firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('stats')
        .doc('user_stats')
        .set(stats.toMap());
  }

  // Get user stats
  Future<UserStats> getUserStats(String userId) async {
    final doc = await _firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('stats')
        .doc('user_stats')
        .get();

    if (!doc.exists) {
      // If stats don't exist, create them
      await createInitialStats(userId);
      return UserStats();
    }

    return UserStats.fromMap(doc.data()!);
  }

  // Update user stats
  Future<void> updateUserStats(String userId, UserStats stats) async {
    await _firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('stats')
        .doc('user_stats')
        .update(stats.toMap());
  }

  // Add activity to recent activities
  Future<void> addActivity(String userId, Map<String, dynamic> activity) async {
    final stats = await getUserStats(userId);
    final updatedActivities = [activity, ...stats.recentActivities];
    // Keep only last 10 activities
    if (updatedActivities.length > 10) {
      updatedActivities.removeLast();
    }

    await updateUserStats(
      userId,
      stats.copyWith(recentActivities: updatedActivities),
    );
  }

  // Update points and activity count
  Future<void> updatePointsAndActivity(
    String userId, {
    required int points,
    required String activityType,
  }) async {
    final stats = await getUserStats(userId);
    int itemsRecycled = stats.itemsRecycled;
    int itemsSold = stats.itemsSold;
    int itemsDonated = stats.itemsDonated;

    switch (activityType) {
      case 'recycle':
        itemsRecycled++;
        break;
      case 'sell':
        itemsSold++;
        break;
      case 'donate':
        itemsDonated++;
        break;
    }

    await updateUserStats(
      userId,
      stats.copyWith(
        totalPoints: stats.totalPoints + points,
        itemsRecycled: itemsRecycled,
        itemsSold: itemsSold,
        itemsDonated: itemsDonated,
      ),
    );
  }

  // Get user preferences
  Future<UserPreferences> getUserPreferences(String userId) async {
    final doc = await _firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('user_preferences')
        .get();

    if (!doc.exists) {
      // Create default preferences if they don't exist
      final defaultPreferences = UserPreferences(
        emailNotifications: true,
        locationEnabled: true,
        lastUpdated: DateTime.now(),
      );
      await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('user_preferences')
          .set(defaultPreferences.toMap());
      return defaultPreferences;
    }

    return UserPreferences.fromMap(doc.data()!);
  }

  // Update user preferences
  Future<void> updateUserPreferences(
    String userId,
    UserPreferences preferences,
  ) async {
    await _firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('user_preferences')
        .update(preferences.toMap());
  }

  // Update email notifications preference
  Future<void> updateEmailNotifications(String userId, bool enabled) async {
    final preferences = await getUserPreferences(userId);
    await updateUserPreferences(
      userId,
      preferences.copyWith(
        emailNotifications: enabled,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  // Update location settings preference
  Future<void> updateLocationSettings(String userId, bool enabled) async {
    final preferences = await getUserPreferences(userId);
    await updateUserPreferences(
      userId,
      preferences.copyWith(
        locationEnabled: enabled,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  // Create a new listing
  Future<void> createListing({
    required String userId,
    required String title,
    required String description,
    required String type,
    required String category,
    required String itemCondition,
    List<String>? imageUrls,
    double? price,
    bool? isNegotiable,
    String? itemWeight,
    String? recyclingCenterId,
    String? ngoId,
    DateTime? scheduledPickupDate,
    String? pickupNotes,
  }) async {
    try {
      final listing = Listing(
        id: FirebaseFirestore.instance.collection('listings').doc().id,
        userId: userId,
        title: title,
        description: description,
        type: type,
        category: category,
        itemCondition: itemCondition,
        imageUrl: imageUrls?.isNotEmpty == true ? imageUrls!.first : null,
        price: price,
        isNegotiable: isNegotiable,
        itemWeight: itemWeight,
        recyclingCenterId: recyclingCenterId,
        ngoId: ngoId,
        status: 'active',
        createdAt: DateTime.now(),
        scheduledPickupDate: scheduledPickupDate,
        pickupNotes: pickupNotes,
      );

      await FirebaseFirestore.instance
          .collection('listings')
          .doc(listing.id)
          .set(listing.toMap());
    } catch (e) {
      throw Exception('Failed to create listing: $e');
    }
  }

  // Get user listings
  Stream<List<Listing>> getUserListings(String userId) {
    return _firebaseService.firestore
        .collection('listings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final listings =
          snapshot.docs.map((doc) => Listing.fromMap(doc.data())).toList();
      // Sort the listings in memory instead of in the query
      listings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return listings;
    });
  }

  // Update listing status
  Future<void> updateListingStatus(String listingId, String status) async {
    final updateData = {
      'status': status,
      if (status == 'completed') 'completedAt': Timestamp.now(),
    };

    await _firebaseService.firestore
        .collection('listings')
        .doc(listingId)
        .update(updateData);
  }

  // Delete listing
  Future<void> deleteListing(String listingId) async {
    await _firebaseService.firestore
        .collection('listings')
        .doc(listingId)
        .delete();
  }
}
