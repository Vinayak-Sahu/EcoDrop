import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RecycleScreen extends StatefulWidget {
  const RecycleScreen({super.key});

  @override
  State<RecycleScreen> createState() => _RecycleScreenState();
}

class _RecycleScreenState extends State<RecycleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Electronics';
  String _selectedQuantity = '1-2 items';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final List<RecyclingCenter> _recyclingCenters = [
    RecyclingCenter(
      name: 'Green Earth Recycling',
      address: '123 Eco Street, City',
      rating: 4.5,
      distance: '2.5 km',
      position: const LatLng(20.5937, 78.9629),
      categories: ['Electronics', 'Computers', 'Mobile Devices'],
    ),
    RecyclingCenter(
      name: 'E-Waste Solutions',
      address: '456 Green Avenue, City',
      rating: 4.2,
      distance: '3.8 km',
      position: const LatLng(20.5937, 78.9629),
      categories: ['Electronics', 'Accessories'],
    ),
    RecyclingCenter(
      name: 'Tech Recycle Hub',
      address: '789 Sustainable Road, City',
      rating: 4.7,
      distance: '5.1 km',
      position: const LatLng(20.5937, 78.9629),
      categories: ['Computers', 'Mobile Devices', 'Accessories'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  void _updateMarkers() {
    _markers.clear();
    for (var center in _recyclingCenters) {
      _markers.add(
        Marker(
          markerId: MarkerId(center.name),
          position: center.position,
          infoWindow: InfoWindow(
            title: center.name,
            snippet: center.address,
          ),
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement recycling pickup scheduling
      print('Scheduling pickup for: ${_selectedDate.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle E-Waste'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Map Section
              Card(
                child: SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(20.5937, 78.9629),
                      zoom: 12,
                    ),
                    markers: _markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recycling Centers List
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nearby Recycling Centers',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recyclingCenters.length,
                        itemBuilder: (context, index) {
                          final center = _recyclingCenters[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.recycling),
                            ),
                            title: Text(center.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(center.address),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber[700],
                                    ),
                                    Text(' ${center.rating}'),
                                    const SizedBox(width: 16),
                                    Text('${center.distance} away'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to center details
                              },
                              child: const Text('Select'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pickup Details Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickup Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'E-Waste Category',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Electronics',
                            child: Text('Electronics'),
                          ),
                          DropdownMenuItem(
                            value: 'Computers',
                            child: Text('Computers'),
                          ),
                          DropdownMenuItem(
                            value: 'Mobile Devices',
                            child: Text('Mobile Devices'),
                          ),
                          DropdownMenuItem(
                            value: 'Accessories',
                            child: Text('Accessories'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedQuantity,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: '1-2 items',
                            child: Text('1-2 items'),
                          ),
                          DropdownMenuItem(
                            value: '3-5 items',
                            child: Text('3-5 items'),
                          ),
                          DropdownMenuItem(
                            value: '6-10 items',
                            child: Text('6-10 items'),
                          ),
                          DropdownMenuItem(
                            value: 'More than 10 items',
                            child: Text('More than 10 items'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedQuantity = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Pickup Date'),
                        subtitle: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _selectDate,
                      ),
                      ListTile(
                        title: const Text('Pickup Time'),
                        subtitle: Text(_selectedTime.format(context)),
                        trailing: const Icon(Icons.access_time),
                        onTap: _selectTime,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Schedule Pickup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecyclingCenter {
  final String name;
  final String address;
  final double rating;
  final String distance;
  final LatLng position;
  final List<String> categories;

  RecyclingCenter({
    required this.name,
    required this.address,
    required this.rating,
    required this.distance,
    required this.position,
    required this.categories,
  });
}
