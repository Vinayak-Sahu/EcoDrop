import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../services/user_service.dart';
import '../../models/listing_model.dart';
import 'dart:io';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  final UserService _userService = UserService();
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view your listings')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Listings'),
              ),
              const PopupMenuItem(
                value: 'active',
                child: Text('Active'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completed'),
              ),
              const PopupMenuItem(
                value: 'cancelled',
                child: Text('Cancelled'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Listing>>(
        stream: _userService.getUserListings(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final listings = snapshot.data!;
          final filteredListings = _selectedFilter == 'all'
              ? listings
              : listings.where((l) => l.status == _selectedFilter).toList();

          if (filteredListings.isEmpty) {
            return Center(
              child: Text(
                _selectedFilter == 'all'
                    ? 'No listings found'
                    : 'No $_selectedFilter listings found',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredListings.length,
            itemBuilder: (context, index) {
              final listing = filteredListings[index];
              return _buildListingCard(listing);
            },
          );
        },
      ),
    );
  }

  Widget _buildListingCard(Listing listing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listing.imageUrl != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                listing.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        listing.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusChip(listing.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  listing.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _getIconForType(listing.type),
                      size: 16,
                      color: _getColorForType(listing.type),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      listing.type.toUpperCase(),
                      style: TextStyle(
                        color: _getColorForType(listing.type),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.category,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      listing.category,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                if (listing.type == 'sell' && listing.price != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '₹${listing.price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Listed on ${_formatDate(listing.createdAt)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (listing.status == 'active') ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _showUpdateStatusDialog(
                          context,
                          listing,
                          'completed',
                        ),
                        child: const Text('Mark as Completed'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => _showUpdateStatusDialog(
                          context,
                          listing,
                          'cancelled',
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'active':
        color = Colors.green;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'sell':
        return Icons.sell;
      case 'donate':
        return Icons.volunteer_activism;
      case 'recycle':
        return Icons.recycling;
      default:
        return Icons.category;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'sell':
        return Colors.orange;
      case 'donate':
        return Colors.blue;
      case 'recycle':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showUpdateStatusDialog(
    BuildContext context,
    Listing listing,
    String newStatus,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          newStatus == 'completed' ? 'Mark as Completed' : 'Cancel Listing',
        ),
        content: Text(
          newStatus == 'completed'
              ? 'Are you sure you want to mark this listing as completed?'
              : 'Are you sure you want to cancel this listing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  newStatus == 'completed' ? Colors.green : Colors.red,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _userService.updateListingStatus(listing.id, newStatus);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                newStatus == 'completed'
                    ? 'Listing marked as completed'
                    : 'Listing cancelled',
              ),
              backgroundColor:
                  newStatus == 'completed' ? Colors.green : Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating listing: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
