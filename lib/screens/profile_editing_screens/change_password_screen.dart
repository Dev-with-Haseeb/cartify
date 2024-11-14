import 'package:cartify/screens/bottom_navbar/bottom_navbar.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorDialog("New password and confirm password do not match.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorDialog("No user is logged in.");
        return;
      }

      // Re-authenticate the user to verify the current password
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);

      // Update password
      await user.updatePassword(newPassword);

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

      // Show success message
      _showSuccessDialog("Password changed successfully.");
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      switch (error.code) {
        case 'wrong-password':
          errorMessage = 'The password is wrong.';
          break;
        case 'invalid-credential':
          errorMessage = 'The password is wrong.';
          break;
        default:
          errorMessage = error.message ?? 'An unknown error occurred.';
          break;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final passwordRegex =
      RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Password must be at least 8 characters, with an uppercase letter, a number, and a special character';
    }
    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
          title: const Text("Change Password"),
          backgroundColor: AppColors.mainColor,
          foregroundColor: Colors.white,
        ),
        body: FocusScope(
          node: _focusScopeNode,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                      focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                      width: 2), // Color when focused
                                ),
                    ),
                    cursorColor: AppColors.mainColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                      width: 2), // Color when focused
                                ),
                    ),
                    cursorColor: AppColors.mainColor,
                    validator: passwordValidator,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm New Password',
                      focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                      width: 2), // Color when focused
                                ),
                    ),
                    cursorColor: AppColors.mainColor,
                    validator: passwordValidator,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Change Password'),
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
