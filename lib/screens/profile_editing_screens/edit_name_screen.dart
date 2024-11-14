import 'package:cartify/screens/bottom_navbar/bottom_navbar.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({
    super.key,
    required this.initialFirstName,
    required this.initialLastName,
  });

  final String initialFirstName;
  final String initialLastName;

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final _form = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  late String _enteredFirstName;
  late String _enteredLastName;

  @override
  void initState() {
    super.initState();
    _enteredFirstName = widget.initialFirstName;
    _enteredLastName = widget.initialLastName;
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
      'firstName': _enteredFirstName,
      'lastName': _enteredLastName,
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
          title: const Text('Edit Name'),
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
                    initialValue: _enteredFirstName,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.mainColor,
                            width: 2),
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
                      _enteredFirstName = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: _enteredLastName,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.mainColor,
                            width: 2),
                      ),
                    ),
                    cursorColor: AppColors.mainColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredLastName = value!;
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
