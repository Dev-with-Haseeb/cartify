import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? Avatar;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.Avatar,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      Avatar: data['avatar'],
    );
  }

  String get fullName => "$firstName $lastName";

  UserModel copyWith({String? Avatar}) {
    return UserModel(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      Avatar: Avatar ?? this.Avatar,
    );
  }
}
