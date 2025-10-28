import 'dart:convert';

class User {
  final String id;
  final String name;
  final int phoneNumber;
  final String? image;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      image: json['image'],
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'image': image,
    });
  }
}
