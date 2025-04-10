import 'package:flutter/material.dart';

class FullRewardHistoryScreen extends StatefulWidget {
  const FullRewardHistoryScreen({super.key});

  @override
  State<FullRewardHistoryScreen> createState() =>
      _FullRewardHistoryScreenState();
}

class _FullRewardHistoryScreenState extends State<FullRewardHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Recycling', 'Donation', 'Selling'];

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
      body: Column(
        children: [
          // Summary Card
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
                      'Total Points Earned',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '5,250',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
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

          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 20, // Sample data count
              itemBuilder: (context, index) {
                // Generate sample data based on index
                final date = DateTime.now().subtract(Duration(days: index));
                final types = ['Recycling', 'Donation', 'Selling'];
                final type = types[index % types.length];
                final points = [500, 300, 200, 400, 600][index % 5];
                final icons = {
                  'Recycling': Icons.recycling,
                  'Donation': Icons.volunteer_activism,
                  'Selling': Icons.sell,
                };
                final colors = {
                  'Recycling': Colors.green,
                  'Donation': Colors.blue,
                  'Selling': Colors.orange,
                };

                // Apply filter
                if (_selectedFilter != 'All' && _selectedFilter != type) {
                  return const SizedBox.shrink();
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colors[type]!.withOpacity(0.1),
                      child: Icon(icons[type], color: colors[type]),
                    ),
                    title: Text('$type Reward'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Earned $points points'),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '+$points',
                      style: TextStyle(
                        color: colors[type],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // TODO: Show reward details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
