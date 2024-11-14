import 'package:cartify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

 
  Future<void> fetchUserData(String uid) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      _user = UserModel.fromFirestore(userDoc);
    } else {
      _user = null;
    }
  } catch (error) {
    throw Exception("Failed to fetch user data: $error");
  }
}

}
