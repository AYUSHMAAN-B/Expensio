import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String id;
  final String name;
  final String email;
  final String? photo;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      photo: doc['photo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
    };
  }
}
