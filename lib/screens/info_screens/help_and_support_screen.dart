import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help and Support'),
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor),
            ),
            const SizedBox(height: 10),
            _fAQItem('How do I reset my password?',
                'Go to the Change Password screen and follow the instructions.'),
            _fAQItem('How do I update my profile?',
                'Navigate to the profile section, tap Edit, and update your details.'),
            _fAQItem('How do I contact support?',
                'Use the contact form below or email us directly.'),
            const SizedBox(height: 20),
            const Text(
              'Contact Support',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any issues, feel free to reach out to our support team.',
              style: TextStyle(color: AppColors.mainColor),
            ),
            const SizedBox(height: 10),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Email:    ',
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'cartify2005@cartify.app',
                  style: TextStyle(color: AppColors.mainColor),
                )
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Phone:  ',
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '03219876543',
                  style: TextStyle(color: AppColors.mainColor),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(answer),
        ],
      ),
    );
  }
}
