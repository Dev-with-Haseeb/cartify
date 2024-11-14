import 'package:cartify/screens/bottom_navbar/bottom_navbar.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectAvatar extends StatefulWidget {
  const SelectAvatar({super.key});

  @override
  State<SelectAvatar> createState() => _SelectAvatarState();
}

class _SelectAvatarState extends State<SelectAvatar> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedAvatar;

  final List<String> avatars = [
    'assets/avatars/avatar_1.png',
    'assets/avatars/avatar_2.png',
    'assets/avatars/avatar_3.png',
    'assets/avatars/avatar_4.png',
    'assets/avatars/avatar_5.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  // Load avatar path from Firestore
  Future<void> _loadAvatar() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc['avatar'] != null) {
        setState(() {
          selectedAvatar = userDoc['avatar'];
        });
      }
    } catch (e) {
      return;
    }
  }

  // Save selected avatar path to Firestore
  Future<void> _saveAvatar() async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'avatar': selectedAvatar,
      }, SetOptions(merge: true));
      if (!mounted) {
        return;
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const BottomNavbar(
                  screenIndex: 3,
                )),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Avatar selected successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save avatar. Try again.")),
      );
    }
  }

  void _selectAvatar(String avatarPath) {
    setState(() {
      selectedAvatar = avatarPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Avatar'),
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFF5F5F5),
              radius: 60,
              backgroundImage: selectedAvatar != null
                  ? AssetImage(selectedAvatar!) as ImageProvider
                  : null,
              child: selectedAvatar == null
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.mainColor,
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose an Avatar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: avatars.map((avatarPath) {
                return GestureDetector(
                  onTap: () => _selectAvatar(avatarPath),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(avatarPath),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: selectedAvatar != null
                  ? _saveAvatar
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Select an Avatar First")),
      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm Selection'),
            ),
          ],
        ),
      ),
    );
  }
}
