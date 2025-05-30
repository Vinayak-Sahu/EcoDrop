import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/ngo.dart';
import '../services/ngo_service.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import 'success_screen.dart';
import 'dart:io';

class ScheduleNGOPickupScreen extends StatefulWidget {
  final String itemTitle;
  final String itemCategory;
  final String itemCondition;
  final String itemDescription;
  final String ngoId;
  final List<String> imagePaths;

  const ScheduleNGOPickupScreen({
    super.key,
    required this.itemTitle,
    required this.itemCategory,
    required this.itemCondition,
    required this.itemDescription,
    required this.ngoId,
    required this.imagePaths,
  });

  @override
  State<ScheduleNGOPickupScreen> createState() =>
      _ScheduleNGOPickupScreenState();
}

class _ScheduleNGOPickupScreenState extends State<ScheduleNGOPickupScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesController = TextEditingController();
  bool _isLoading = false;
  NGO? _selectedNGO;
  final NGOService _ngoService = NGOService();

  @override
  void initState() {
    super.initState();
    _loadNGO();
  }

  Future<void> _loadNGO() async {
    try {
      final ngo = await _ngoService.getNGOById(widget.ngoId);
      setState(() {
        _selectedNGO = ngo;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load NGO: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
        const SnackBar(
          content: Text('Please select both date and time'),
          backgroundColor: Colors.red,
        ),
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
        type: 'donate',
        category: widget.itemCategory,
        itemCondition: widget.itemCondition,
        ngoId: widget.ngoId,
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
              message: 'Donation Scheduled Successfully!',
              details:
                  'Your donation pickup is scheduled for ${DateFormat('MMMM d, yyyy').format(scheduledDateTime)} at ${_selectedTime!.format(context)}',
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
  void dispose() {
    _notesController.dispose();
    super.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Item Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
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
                    _buildSummaryRow('Title', widget.itemTitle),
                    _buildSummaryRow('Category', widget.itemCategory),
                    _buildSummaryRow('Condition', widget.itemCondition),
                    const Divider(),
                    Text(
                      'NGO Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (_selectedNGO != null) ...[
                      _buildSummaryRow('Name', _selectedNGO!.name),
                      _buildSummaryRow('Address', _selectedNGO!.address),
                      _buildSummaryRow('Contact', _selectedNGO!.contactNumber),
                      _buildSummaryRow('Email', _selectedNGO!.email),
                    ] else
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date and Time Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date and Time',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Pickup Date'),
                      subtitle: Text(
                        _selectedDate != null
                            ? DateFormat('MMMM d, yyyy').format(_selectedDate!)
                            : 'Select date',
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Pickup Time'),
                      subtitle: Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Select time',
                      ),
                      onTap: () => _selectTime(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pickup Address
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
            const SizedBox(height: 16),

            // Additional Notes
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

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Confirm Pickup'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
