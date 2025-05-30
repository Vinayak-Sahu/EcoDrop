import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import 'success_screen.dart';
import 'dart:io';

class ScheduleSellPickupScreen extends StatefulWidget {
  final String itemTitle;
  final String itemCategory;
  final String itemCondition;
  final String itemDescription;
  final double price;
  final bool isNegotiable;
  final List<String> imagePaths;

  const ScheduleSellPickupScreen({
    Key? key,
    required this.itemTitle,
    required this.itemCategory,
    required this.itemCondition,
    required this.itemDescription,
    required this.price,
    required this.isNegotiable,
    required this.imagePaths,
  }) : super(key: key);

  @override
  State<ScheduleSellPickupScreen> createState() =>
      _ScheduleSellPickupScreenState();
}

class _ScheduleSellPickupScreenState extends State<ScheduleSellPickupScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleSubmit() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userService = UserService();

      // Combine date and time
      final scheduledDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Create listing in Firestore
      await userService.createListing(
        userId: authProvider.currentUser!.uid,
        title: widget.itemTitle,
        description: widget.itemDescription,
        type: 'sell',
        category: widget.itemCategory,
        itemCondition: widget.itemCondition,
        price: widget.price,
        isNegotiable: widget.isNegotiable,
        scheduledPickupDate: scheduledDateTime,
        pickupNotes: _notesController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              message: 'Item Listed Successfully!',
              details:
                  'Your item pickup is scheduled for ${DateFormat('MMMM d, yyyy').format(scheduledDateTime)} at ${_selectedTime!.format(context)}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create listing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final userAddress = profileProvider.profile?.address ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Pickup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            // Add Image Gallery
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imagePaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(widget.imagePaths[index]),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Title: ${widget.itemTitle}'),
            Text('Category: ${widget.itemCategory}'),
            Text('Condition: ${widget.itemCondition}'),
            Text('Price: ₹${widget.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text(
              'Pickup Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Select Date'),
              subtitle: Text(_selectedDate == null
                  ? 'No date selected'
                  : DateFormat('MMM dd, yyyy').format(_selectedDate!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: const Text('Select Time'),
              subtitle: Text(_selectedTime == null
                  ? 'No time selected'
                  : _selectedTime!.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup Address',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Your Address'),
                      subtitle: Text(userAddress.isEmpty
                          ? 'No address found in profile'
                          : userAddress),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.info),
                      title: Text('Pickup Instructions'),
                      subtitle: Text(
                        'Please ensure the items are properly packed and placed at the entrance.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Notes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: 'Add any special instructions or notes...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Schedule Pickup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
