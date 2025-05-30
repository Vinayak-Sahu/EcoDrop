import 'package:flutter/material.dart';

class RewardSystemScreen extends StatelessWidget {
  const RewardSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward System'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // How it works section
            _buildSection(
              context,
              'How It Works',
              'Earn points by recycling, selling, or donating items through EcoDrop. '
                  'The more you contribute to a sustainable environment, the more points you earn!',
              Icons.eco,
              Colors.green,
            ),
            const SizedBox(height: 24),

            // Points breakdown
            _buildSection(
              context,
              'Points Breakdown',
              '• Recycling: 50 points per item\n'
                  '• Selling: 30 points per item\n'
                  '• Donating: 40 points per item',
              Icons.star,
              Colors.amber,
            ),
            const SizedBox(height: 24),

            // Available Rewards
            _buildSection(
              context,
              'Available Rewards',
              '• ₹1000 Amazon Voucher (2000 points)\n'
                  '• Plant a Tree (1000 points)\n'
                  '• Eco-Friendly Water Bottle (1500 points)\n'
                  '• ₹500 Flipkart Voucher (1000 points)',
              Icons.card_giftcard,
              Colors.blue,
            ),
            const SizedBox(height: 24),

            // How to redeem
            _buildSection(
              context,
              'How to Redeem',
              '1. Accumulate enough points for your desired reward\n'
                  '2. Go to the Stats page\n'
                  '3. Find the reward you want\n'
                  '4. Click the "Redeem" button\n'
                  '5. Confirm your redemption',
              Icons.how_to_reg,
              Colors.purple,
            ),
            const SizedBox(height: 24),

            // Terms and conditions
            _buildSection(
              context,
              'Terms & Conditions',
              '• Rewards are valid for 30 days from the date of availability\n'
                  '• Points cannot be transferred between accounts\n'
                  '• Rewards are subject to availability\n'
                  '• EcoDrop reserves the right to modify the reward system',
              Icons.gavel,
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
