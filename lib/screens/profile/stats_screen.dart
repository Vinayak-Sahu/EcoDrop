import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../services/user_service.dart';
import '../../models/user_stats.dart';
import 'reward_system_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final UserService _userService = UserService();
  UserStats? _userStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId =
          Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        final stats = await _userService.getUserStats(userId);
        setState(() {
          _userStats = stats;
        });
      }
    } catch (e) {
      debugPrint('Error loading user stats: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Statistics & Rewards'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userStats == null
              ? const Center(child: Text('No statistics available'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Points Summary Card
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryContainer,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Points',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _userStats!.totalPoints.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.card_giftcard,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Stats Overview
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Activity Overview',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(
                                    'Items Recycled',
                                    _userStats!.itemsRecycled.toString(),
                                    Colors.green),
                                _buildStatItem(
                                    'Items Sold',
                                    _userStats!.itemsSold.toString(),
                                    Colors.orange),
                                _buildStatItem(
                                    'Items Donated',
                                    _userStats!.itemsDonated.toString(),
                                    Colors.blue),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Recent Activity
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Activity',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            if (_userStats!.recentActivities.isEmpty)
                              const Center(
                                child: Text('No recent activities'),
                              )
                            else
                              ..._userStats!.recentActivities.map((activity) =>
                                  _buildRewardItem(
                                    context,
                                    activity['title'] ?? '',
                                    activity['description'] ?? '',
                                    activity['date'] != null
                                        ? (activity['date'] as Timestamp)
                                            .toDate()
                                        : DateTime.now(),
                                    _getIconForActivity(activity['type'] ?? ''),
                                    _getColorForActivity(
                                        activity['type'] ?? ''),
                                  )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Available Rewards
                      _buildAvailableRewardsSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildAvailableRewardsSection() {
    if (_userStats == null || _userStats!.availableRewards.isEmpty) {
      return const Center(
        child: Text('No rewards available yet'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Available Rewards',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RewardSystemScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Learn More'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _userStats!.availableRewards.length,
          itemBuilder: (context, index) {
            final reward = _userStats!.availableRewards[index];
            return _buildAvailableRewardCard(
              context,
              reward['title'] as String,
              reward['points'].toString(),
              _getRewardIcon(reward['type'] as String),
              _getRewardColor(reward['type'] as String),
            );
          },
        ),
      ],
    );
  }

  IconData _getRewardIcon(String type) {
    switch (type) {
      case 'voucher':
        return Icons.card_giftcard;
      case 'environment':
        return Icons.eco;
      case 'product':
        return Icons.shopping_bag;
      default:
        return Icons.card_giftcard;
    }
  }

  Color _getRewardColor(String type) {
    switch (type) {
      case 'voucher':
        return Colors.blue;
      case 'environment':
        return Colors.green;
      case 'product':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconForActivity(String type) {
    switch (type) {
      case 'recycle':
        return Icons.recycling;
      case 'donate':
        return Icons.volunteer_activism;
      case 'sell':
        return Icons.sell;
      default:
        return Icons.star;
    }
  }

  Color _getColorForActivity(String type) {
    switch (type) {
      case 'recycle':
        return Colors.green;
      case 'donate':
        return Colors.blue;
      case 'sell':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardItem(
    BuildContext context,
    String title,
    String description,
    DateTime date,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Show reward details
        },
      ),
    );
  }

  Widget _buildAvailableRewardCard(
    BuildContext context,
    String title,
    String points,
    IconData icon,
    Color color,
  ) {
    final reward = _userStats!.availableRewards.firstWhere(
      (r) => r['title'] == title,
      orElse: () => {},
    );
    final description = reward['description'] ?? '';
    final pointsRequired = reward['points'] ?? 0;
    final validUntil = reward['validUntil'] != null
        ? (reward['validUntil'] as Timestamp).toDate()
        : DateTime.now().add(const Duration(days: 30));
    final canRedeem = _userStats!.totalPoints >= pointsRequired;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valid until: ${validUntil.day}/${validUntil.month}/${validUntil.year}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Points required: $pointsRequired',
                      style: TextStyle(
                        color: canRedeem ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: canRedeem
                      ? () {
                          _showRedemptionDialog(context, title, pointsRequired);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canRedeem ? color : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Redeem'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRedemptionDialog(
    BuildContext context,
    String rewardTitle,
    int pointsRequired,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redeem Reward'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to redeem $rewardTitle?'),
            const SizedBox(height: 8),
            Text(
              'This will cost you $pointsRequired points.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: Implement reward redemption logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reward redemption request submitted!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
