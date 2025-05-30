class NGO {
  final String id;
  final String name;
  final String description;
  final String address;
  final String contactNumber;
  final String email;
  final List<String> acceptedCategories;
  final double latitude;
  final double longitude;
  final String imageUrl;

  NGO({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.acceptedCategories,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });

  factory NGO.fromJson(Map<String, dynamic> json) {
    return NGO(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      contactNumber: json['contactNumber'] as String,
      email: json['email'] as String,
      acceptedCategories: List<String>.from(json['acceptedCategories']),
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'contactNumber': contactNumber,
      'email': email,
      'acceptedCategories': acceptedCategories,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
    };
  }
}
