import 'package:cartify/screens/bottom_navbar/bottom_navbar.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUsernameScreen extends StatefulWidget {
  final String initialUsername;

  const EditUsernameScreen({super.key, required this.initialUsername});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final _form = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  late String _enteredUsername;

  @override
  void initState() {
    super.initState();
    _enteredUsername = widget.initialUsername;
  }

  _onSaved() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

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

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'username': _enteredUsername,
    });
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Edit Username'),
          backgroundColor: AppColors.mainColor,
          foregroundColor: Colors.white,
        ),
        body: FocusScope(
          node: _focusScopeNode,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    initialValue: _enteredUsername,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.mainColor,
                            width: 2), // Color when focused
                      ),
                    ),
                    cursorColor: AppColors.mainColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredUsername = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onSaved,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
