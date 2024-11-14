import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/material.dart';

class PrivacyAndSecurityScreen extends StatelessWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy and Security'),
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.mainColor),
            ),
            SizedBox(height: 10),
            Text(
              'We value your privacy. Your data is stored securely and is not shared with third parties without your consent. Please read through our privacy policy to understand how we protect your information.',
              style: TextStyle(color: AppColors.mainColor),
            ),
            SizedBox(height: 20),
            Text(
              'Data Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.mainColor),
            ),
            SizedBox(height: 10),
            Text(
              'Our app uses end-to-end encryption and follows industry-standard security protocols to ensure your data remains safe and secure.',
              style: TextStyle(color: AppColors.mainColor),
            ),
            SizedBox(height: 20),
            Text(
              'User Rights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.mainColor),
            ),
            SizedBox(height: 10),
            Text(
              'You have the right to access, update, and delete your data. For more details, please contact our support team.',
              style: TextStyle(color: AppColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
