import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ngo.dart';

class NGOService {
  // List of real NGOs in Delhi working with e-waste management
  final List<NGO> _delhiNGOs = [
    NGO(
      id: 'ngo1',
      name: 'Toxics Link',
      description:
          'Toxics Link is a leading environmental NGO in India working on e-waste management and environmental justice. They focus on research, advocacy, and awareness programs.',
      address: 'H-2, Jungpura Extension, New Delhi - 110014',
      contactNumber: '+91 11 2432 8006',
      email: 'info@toxicslink.org',
      acceptedCategories: [
        'Electronics',
        'Computers',
        'Mobile Devices',
        'Accessories'
      ],
      latitude: 28.5675,
      longitude: 77.2505,
      imageUrl:
          'https://toxicslink.org/wp-content/uploads/2020/03/toxicslink-logo.png',
    ),
    NGO(
      id: 'ngo2',
      name: 'Chintan Environmental Research and Action Group',
      description:
          'Chintan works on sustainable waste management including e-waste. They run collection centers and awareness programs across Delhi.',
      address: 'F-1, Hauz Khas Enclave, New Delhi - 110016',
      contactNumber: '+91 11 2653 1386',
      email: 'info@chintan-india.org',
      acceptedCategories: [
        'Electronics',
        'Computers',
        'Mobile Devices',
        'Accessories'
      ],
      latitude: 28.5478,
      longitude: 77.2014,
      imageUrl:
          'https://chintan-india.org/wp-content/uploads/2020/04/chintan-logo.png',
    ),
    NGO(
      id: 'ngo3',
      name: 'Swechha',
      description:
          'Swechha runs the "We Mean To Clean" initiative focusing on e-waste management and recycling. They conduct regular collection drives and awareness programs.',
      address: 'K-213, New Manglapuri, New Delhi - 110030',
      contactNumber: '+91 11 2954 1188',
      email: 'info@swechha.org',
      acceptedCategories: ['Electronics', 'Mobile Devices', 'Accessories'],
      latitude: 28.5122,
      longitude: 77.1025,
      imageUrl:
          'https://swechha.org/wp-content/uploads/2020/04/swechha-logo.png',
    ),
    NGO(
      id: 'ngo4',
      name: 'Greenpeace India',
      description:
          'Greenpeace India runs various e-waste management initiatives and campaigns for responsible e-waste disposal and recycling.',
      address:
          'Greenpeace India, 60 Wellington Street, Civil Lines, New Delhi - 110054',
      contactNumber: '+91 11 2431 7571',
      email: 'info@greenpeace.org',
      acceptedCategories: [
        'Electronics',
        'Computers',
        'Mobile Devices',
        'Accessories'
      ],
      latitude: 28.6692,
      longitude: 77.2127,
      imageUrl:
          'https://www.greenpeace.org/static/planet4-india-stateless/2019/01/Greenpeace-logo.png',
    ),
    NGO(
      id: 'ngo5',
      name: 'Centre for Science and Environment (CSE)',
      description:
          'CSE runs the "Green Rating Project" and works on e-waste management policies and implementation in Delhi.',
      address: '41, Tughlakabad Institutional Area, New Delhi - 110062',
      contactNumber: '+91 11 2995 5124',
      email: 'cse@cseindia.org',
      acceptedCategories: ['Electronics', 'Computers', 'Mobile Devices'],
      latitude: 28.5009,
      longitude: 77.2502,
      imageUrl: 'https://www.cseindia.org/sites/default/files/cse-logo.png',
    ),
  ];

  Future<List<NGO>> getNGOsByAddress(String userAddress) async {
    // Return Delhi NGOs regardless of address
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _delhiNGOs;
  }

  Future<List<NGO>> getNGOsByLocation(double latitude, double longitude) async {
    // Return Delhi NGOs regardless of location
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _delhiNGOs;
  }

  Future<NGO> getNGOById(String id) async {
    // TODO: Implement actual API call
    // For now, return a mock NGO
    return NGO(
      id: id,
      name: 'Eco NGO',
      description: 'A dedicated NGO for e-waste management',
      address: '123 Green Street, Eco City, EC 12345',
      contactNumber: '+1 (555) 123-4567',
      email: 'contact@eco-ngo.com',
      acceptedCategories: [
        'Electronics',
        'Computers',
        'Mobile Devices',
        'Accessories'
      ],
      latitude: 28.6139,
      longitude: 77.2090,
      imageUrl: 'https://example.com/ngo-image.jpg',
    );
  }
}
