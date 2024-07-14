class Nurse {
  final String key;
  final String name;
  final String phoneNumber;
  final String email;
  final String country;
  final String state;
  final String city;
  final String gender;
  final bool lgbtqSupported;
  final String image; // Assuming you have a field for gender-specific image

  Nurse({
    required this.key,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.country,
    required this.state,
    required this.city,
    required this.gender,
    required this.lgbtqSupported,
    required this.image,
  });

  factory Nurse.fromJson(Map<String, dynamic> json) {
    return Nurse(
      key: json['key'],
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      gender: json['gender'] ?? '',
      lgbtqSupported: json['lgbtqSupported'] ?? false,
      image: json['gender'] == 'female' ? 'lib/assets/female_image.png' : 'lib/assets/male_image.png', // Example paths to local images
    );
  }
}
