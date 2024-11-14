import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/material.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key, required this.initialEmail});

  final String initialEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Email'),
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            initialValue: initialEmail,
            decoration: const InputDecoration(
              labelText: 'Email',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.mainColor, width: 2), // Color when focused
              ),
            ),
            enabled: false,
          ),
        ),
      ),
    );
  }
}
