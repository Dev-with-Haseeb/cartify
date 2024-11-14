import 'package:cartify/screens/bottom_navbar/bottom_navbar.dart';
import 'package:cartify/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cartify/widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final FirebaseAuth _firebase = FirebaseAuth.instance;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key, this.isLogin = true});

  final bool isLogin;

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _form = GlobalKey<FormState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _enteredFirstName = '';
  var _enteredLastName = '';
  late bool _isLogin;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin; // Initialize _isLogin based on the passed value
  }

  _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        if (!mounted) {
          return;
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
          (route) => false, // Remove all previous routes
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        if (!mounted) {
          return;
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
          (route) => false,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'firstName': _enteredFirstName, // Add first name
          'lastName': _enteredLastName,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }

      String errorMessage;

      switch (error.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'This operation is not allowed. Please contact support.';
          break;
        case 'weak-password':
          errorMessage =
              'The password is too weak. Please choose a stronger password.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid email or password.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your connection and try again.';
          break;
        default:
          errorMessage = error.message ?? 'An unknown error occurred.';
          break;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  final emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  final passwordRegex =
      RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    if (value.length > 15) {
      return 'Username must not exceed 15 characters';
    }
    final regex =
        RegExp(r'^[a-zA-Z0-9_]+$'); // Only letters, numbers, and underscores
    if (!regex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null; // If all conditions are met
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Password must be at least 8 characters, with an uppercase letter, a number, and a special character';
    }
    return null;
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
        body: FocusScope(
          node: _focusScopeNode,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(color: AppColors.mainColor),
              ),
              const Positioned(
                top: 10,
                right: 0,
                left: 0,
                child: Logo(),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Don\'t have an account? Create one!'
                        : 'Already have an account? Login!',
                    style: const TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: _isLogin
                      ? MediaQuery.of(context).size.height / 1.9
                      : MediaQuery.of(context).size.height / 1.69,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.mainColor,
                          spreadRadius: 0.1,
                          blurRadius: 9,
                          offset: Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin ? 'Login' : 'Sign Up',
                              style: GoogleFonts.openSans(
                                  fontSize: 32,
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: _isLogin ? 70 : 50,
                            ),
                            if (!_isLogin)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: 'First Name',
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
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: 'Last Name',
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
                                  ),
                                ],
                              ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Username',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor,
                                        width: 2), // Color when focused
                                  ),
                                ),
                                cursorColor: AppColors.mainColor,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                enableSuggestions: false,
                                validator: usernameValidator,
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                      width: 2), // Color when focused
                                ),
                              ),
                              cursorColor: AppColors.mainColor,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: emailValidator,
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                errorMaxLines: 2,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                      width: 2), // Color when focused
                                ),
                              ),
                              cursorColor: AppColors.mainColor,
                              obscureText: true,
                              validator: passwordValidator,
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                            if (_isLogin)
                              Container(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordScreen()));
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ),
                              ),
                            const Expanded(
                              child: SizedBox(
                                height: double.infinity,
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                ),
                                child: Text(
                                  _isLogin ? 'Login' : 'Sign Up',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
