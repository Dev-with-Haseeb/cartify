import 'package:flutter/material.dart';
import 'package:cartify/screens/authentication_screen/authentication_screen.dart'; // Adjust according to your file structure
import 'package:cartify/screens/bottom_navbar/bottom_navbar.dart'; // Adjust according to your file structure
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay of 2 seconds to show splash screen
    Future.delayed(const Duration(seconds: 2), () {
      // Check if the user is already authenticated and navigate accordingly
      if (FirebaseAuth.instance.currentUser != null) {
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
      } else {
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash_logo.png',
          width: 250,
          height: 125,
        ),
      ),
    );
  }
}
