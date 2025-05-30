import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/recycling_center.dart';
import '../services/recycling_center_service.dart';
import '../providers/profile_provider.dart';
import 'success_screen.dart';

class SchedulePickupScreen extends StatefulWidget {
  final String itemTitle;
  final String itemCategory;
  final String itemCondition;
  final String itemWeight;
  final String itemDescription;
  final String recyclingCenterId;
  final List<String> imagePaths;

  const SchedulePickupScreen({
    super.key,
    required this.itemTitle,
    required this.itemCategory,
    required this.itemCondition,
    required this.itemWeight,
    required this.itemDescription,
    required this.recyclingCenterId,
    required this.imagePaths,
  });

  @override
  State<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends State<SchedulePickupScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesController = TextEditingController();
  bool _isLoading = false;
  RecyclingCenter? _selectedCenter;
  final RecyclingCenterService _recyclingService = RecyclingCenterService();

  @override
  void initState() {
    super.initState();
    _loadRecyclingCenter();
  }

  Future<void> _loadRecyclingCenter() async {
    try {
      final center = await _recyclingService
          .getRecyclingCenterById(widget.recyclingCenterId);
      setState(() {
        _selectedCenter = center;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load recycling center: $e'),
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

  void _handleSubmit() {
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

    // TODO: Implement pickup scheduling logic
    // Combine date and time
    final scheduledDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
            message: 'Pickup Scheduled Successfully!',
            details:
                'Your pickup is scheduled for ${DateFormat('MMMM d, yyyy').format(scheduledDateTime)} at ${_selectedTime!.format(context)}',
          ),
        ),
      );
    });
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
                    _buildSummaryRow('Title', widget.itemTitle),
                    _buildSummaryRow('Category', widget.itemCategory),
                    _buildSummaryRow('Condition', widget.itemCondition),
                    _buildSummaryRow('Weight', '${widget.itemWeight} kg'),
                    const Divider(),
                    Text(
                      'Recycling Center',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (_selectedCenter != null) ...[
                      _buildSummaryRow('Name', _selectedCenter!.name),
                      _buildSummaryRow('Address', _selectedCenter!.address),
                      _buildSummaryRow(
                          'Contact', _selectedCenter!.contactNumber),
                      _buildSummaryRow(
                          'Hours', _selectedCenter!.operatingHours),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Rating',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber[700],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text('${_selectedCenter!.rating}'),
                        ],
                      ),
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
