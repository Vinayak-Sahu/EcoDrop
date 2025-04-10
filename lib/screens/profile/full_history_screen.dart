import 'package:flutter/material.dart';
import 'dart:math';

// Activity type constants
const String kActivityTypeRecycling = 'Recycling';
const String kActivityTypeDonation = 'Donation';
const String kActivityTypeSelling = 'Selling';

// Points constants
const int kRecyclingMinPoints = 30;
const int kRecyclingMaxPoints = 70;
const int kDonationMinPoints = 80;
const int kDonationMaxPoints = 120;
const int kSellingMinPoints = 120;
const int kSellingMaxPoints = 180;

// Activity count constants
const int kDefaultActivityCount = 20;
const int kMaxDaysInHistory = 90;

class FullHistoryScreen extends StatefulWidget {
  const FullHistoryScreen({super.key});

  @override
  State<FullHistoryScreen> createState() => _FullHistoryScreenState();
}

class _FullHistoryScreenState extends State<FullHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    kActivityTypeRecycling,
    kActivityTypeDonation,
    kActivityTypeSelling
  ];
  final Random _random = Random();
  late List<Map<String, dynamic>> _activities;

  // Activity type descriptions
  final Map<String, String> _activityDescriptions = {
    kActivityTypeRecycling: 'Earned points for recycling e-waste',
    kActivityTypeDonation: 'Earned points for donating electronics',
    kActivityTypeSelling: 'Earned points for selling used devices',
  };

  // Activity icons
  final Map<String, IconData> _activityIcons = {
    kActivityTypeRecycling: Icons.recycling,
    kActivityTypeDonation: Icons.volunteer_activism,
    kActivityTypeSelling: Icons.sell,
  };

  // Activity colors
  final Map<String, Color> _activityColors = {
    kActivityTypeRecycling: Colors.green,
    kActivityTypeDonation: Colors.blue,
    kActivityTypeSelling: Colors.orange,
  };

  @override
  void initState() {
    super.initState();
    _activities = _generateRandomActivities();
  }

  // Generate random activity data
  List<Map<String, dynamic>> _generateRandomActivities() {
    final List<Map<String, dynamic>> activities = [];
    final types = [
      kActivityTypeRecycling,
      kActivityTypeDonation,
      kActivityTypeSelling
    ];
    final now = DateTime.now();

    // Generate random activities
    for (int i = 0; i < kDefaultActivityCount; i++) {
      final type = types[_random.nextInt(types.length)];
      final points = _getRandomPoints(type);
      final daysAgo = _random.nextInt(kMaxDaysInHistory);
      final date = now.subtract(Duration(days: daysAgo));

      activities.add({
        'type': type,
        'points': points,
        'date': date,
      });
    }

    // Sort activities by date (newest first)
    activities.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return activities;
  }

  int _getRandomPoints(String type) {
    switch (type) {
      case kActivityTypeRecycling:
        return kRecyclingMinPoints +
            _random.nextInt(kRecyclingMaxPoints - kRecyclingMinPoints + 1);
      case kActivityTypeDonation:
        return kDonationMinPoints +
            _random.nextInt(kDonationMaxPoints - kDonationMinPoints + 1);
      case kActivityTypeSelling:
        return kSellingMinPoints +
            _random.nextInt(kSellingMaxPoints - kSellingMinPoints + 1);
      default:
        return kRecyclingMinPoints;
    }
  }

  List<Map<String, dynamic>> get filteredActivities {
    if (_selectedFilter == 'All') {
      return _activities;
    }
    return _activities
        .where((activity) => activity['type'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (String value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _filters.map((String filter) {
                return PopupMenuItem<String>(
                  value: filter,
                  child: Row(
                    children: [
                      if (_selectedFilter == filter)
                        const Icon(Icons.check, size: 20)
                      else
                        const SizedBox(width: 20),
                      Text(filter),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredActivities.length,
        itemBuilder: (context, index) {
          final activity = filteredActivities[index];
          final type = activity['type'] as String;
          final points = activity['points'] as int;
          final date = activity['date'] as DateTime;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _activityColors[type]!.withOpacity(0.1),
                child: Icon(_activityIcons[type], color: _activityColors[type]),
              ),
              title: Text('$type Activity'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_activityDescriptions[type]!),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              trailing: Text(
                '+$points',
                style: TextStyle(
                  color: _activityColors[type],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // TODO: Show activity details
              },
            ),
          );
        },
      ),
    );
  }
}
