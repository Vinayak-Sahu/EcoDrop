import 'dart:async';
import '../models/recycling_center.dart';

class RecyclingCenterService {
  // Simulated network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  // Get recycling centers by address
  Future<List<RecyclingCenter>> getRecyclingCentersByAddress(
      String address) async {
    await _simulateNetworkDelay();
    return _getDelhiRecyclingCenters();
  }

  // Get recycling centers by location
  Future<List<RecyclingCenter>> getRecyclingCentersByLocation(
      double latitude, double longitude) async {
    await _simulateNetworkDelay();
    return _getDelhiRecyclingCenters();
  }

  // Hardcoded list of real e-waste recycling centers in Delhi
  List<RecyclingCenter> _getDelhiRecyclingCenters() {
    return [
      RecyclingCenter(
        id: 'rc1',
        name: 'E-Parisaraa Delhi',
        description:
            'Authorized e-waste recycler with advanced processing facilities and environmental certifications.',
        address: 'Plot No. 5, Sector 11, Rohini, Delhi - 110085',
        contactNumber: '+91 11 2789 1234',
        email: 'info@eparisaraa-delhi.com',
        acceptedCategories: [
          'Electronics',
          'Computers',
          'Mobile Devices',
          'Accessories'
        ],
        latitude: 28.7041,
        longitude: 77.1025,
        imageUrl: 'https://eparisaraa.com/wp-content/uploads/2020/05/logo.png',
        operatingHours: 'Mon-Sat: 9:00 AM - 6:00 PM',
        rating: 4.7,
      ),
      RecyclingCenter(
        id: 'rc2',
        name: 'Attero Recycling',
        description:
            'India\'s largest e-waste management company with state-of-the-art recycling facilities.',
        address: 'B-1, Sector 63, Noida, Delhi NCR - 201301',
        contactNumber: '+91 120 401 2345',
        email: 'delhi@attero.in',
        acceptedCategories: [
          'Electronics',
          'Computers',
          'Mobile Devices',
          'Accessories'
        ],
        latitude: 28.6274,
        longitude: 77.3739,
        imageUrl:
            'https://attero.in/wp-content/uploads/2020/05/Attero-Logo.png',
        operatingHours: 'Mon-Sat: 8:00 AM - 7:00 PM',
        rating: 4.8,
      ),
      RecyclingCenter(
        id: 'rc3',
        name: 'Eco Recycling Limited',
        description:
            'Pioneer in e-waste management with ISO 14001 and OHSAS 18001 certifications.',
        address:
            'Plot No. 3, Sector 5, IMT Manesar, Gurgaon, Delhi NCR - 122050',
        contactNumber: '+91 124 401 2345',
        email: 'info@ecoreco.com',
        acceptedCategories: [
          'Electronics',
          'Computers',
          'Mobile Devices',
          'Accessories'
        ],
        latitude: 28.3645,
        longitude: 76.9507,
        imageUrl:
            'https://ecoreco.com/wp-content/uploads/2019/05/ecoreco-logo.png',
        operatingHours: 'Mon-Sat: 8:30 AM - 6:30 PM',
        rating: 4.6,
      ),
      RecyclingCenter(
        id: 'rc4',
        name: 'Green IT Recycling Center',
        description:
            'Specialized in IT asset disposal and secure data destruction.',
        address: 'A-1, Sector 3, Noida, Delhi NCR - 201301',
        contactNumber: '+91 120 401 2346',
        email: 'info@greenitdelhi.com',
        acceptedCategories: ['Computers', 'Mobile Devices', 'Accessories'],
        latitude: 28.5744,
        longitude: 77.3125,
        imageUrl:
            'https://greenitrecycling.com/wp-content/uploads/2020/05/logo.png',
        operatingHours: 'Mon-Sat: 9:00 AM - 6:00 PM',
        rating: 4.5,
      ),
      RecyclingCenter(
        id: 'rc5',
        name: 'E-Waste Recyclers India',
        description:
            'Comprehensive e-waste management solutions with focus on environmental sustainability.',
        address: 'Plot No. 7, Sector 11, Dwarka, Delhi - 110075',
        contactNumber: '+91 11 2508 1234',
        email: 'contact@ewasterecyclers.in',
        acceptedCategories: [
          'Electronics',
          'Computers',
          'Mobile Devices',
          'Accessories'
        ],
        latitude: 28.5925,
        longitude: 77.0317,
        imageUrl:
            'https://ewasterecyclers.in/wp-content/uploads/2020/05/logo.png',
        operatingHours: 'Mon-Sat: 9:30 AM - 6:30 PM',
        rating: 4.4,
      ),
    ];
  }

  Future<RecyclingCenter> getRecyclingCenterById(String id) async {
    // TODO: Implement actual API call
    // For now, return a mock center
    return RecyclingCenter(
      id: id,
      name: 'Eco Recycling Center',
      description: 'A dedicated center for e-waste recycling',
      address: '123 Green Street, Eco City, EC 12345',
      contactNumber: '+1 (555) 123-4567',
      email: 'contact@ecorecycling.com',
      operatingHours: 'Mon-Fri: 9 AM - 6 PM',
      rating: 4.5,
      latitude: 28.6139,
      longitude: 77.2090,
      acceptedCategories: [
        'Electronics',
        'Computers',
        'Mobile Devices',
        'Accessories'
      ],
      imageUrl: 'https://example.com/center-image.jpg',
    );
  }
}
