class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final DateTime dateOfBirth;
  final String? profileImageUrl;
  final String address;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    this.profileImageUrl,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    String? address,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      address: address ?? this.address,
    );
  }
}
