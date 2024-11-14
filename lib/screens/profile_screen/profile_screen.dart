import 'package:cartify/models/user_model.dart';
import 'package:cartify/screens/authentication_screen/authentication_screen.dart';
import 'package:cartify/screens/info_screens/help_and_support_screen.dart';
import 'package:cartify/screens/info_screens/privacy_and_security_screen.dart';
import 'package:cartify/screens/profile_editing_screens/addresses_screen.dart';
import 'package:cartify/screens/profile_editing_screens/change_password_screen.dart';
import 'package:cartify/screens/profile_editing_screens/edit_name_screen.dart';
import 'package:cartify/screens/profile_editing_screens/edit_username_screen.dart';
import 'package:cartify/screens/profile_editing_screens/email_screen.dart';
import 'package:cartify/screens/profile_editing_screens/select_avatar.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<UserModel?> fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      } else {
        return null;
      }
    } catch (error) {
      if (!mounted) {
        return null;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching user data: $error'),
          duration: const Duration(seconds: 1),
        ),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        title: const Text('Profile'),
      ),
      body: currentUser == null
          ? const Center(child: Text("No user is currently signed in."))
          : FutureBuilder<UserModel?>(
              future: fetchUserData(currentUser.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.mainColor),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Center(
                      child: Text('Error loading user data or no data found.'));
                }
                final user = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: const SelectAvatar(),
                                  withNavBar:
                                      false, // Hides the bottom navigation bar
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              child: CircleAvatar(
                                  backgroundImage: user.Avatar != null
                                      ? AssetImage(user.Avatar!)
                                      : null,
                                  backgroundColor: const Color(0xFFF5F5F5),
                                  radius: 50,
                                  child: user.Avatar == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.person_add,
                                                size: 34,
                                                color: AppColors.mainColor),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Select an Avatar',
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                color: AppColors.mainColor,
                                                fontSize: 10,
                                              ),
                                            )
                                          ],
                                        )
                                      : null),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              user.username,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),

                      // Personal Information Section
                      const ListTile(
                        title: Text('Personal Information',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Name'),
                        subtitle: Text(user.fullName),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: EditNameScreen(
                              initialFirstName: user.firstName,
                              initialLastName: user.lastName,
                            ),
                            withNavBar:
                                false, // Hides the bottom navigation bar
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.alternate_email),
                        title: const Text('Username'),
                        subtitle: Text(user.username),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: EditUsernameScreen(
                                initialUsername: user.username),
                            withNavBar:
                                false, // Hides the bottom navigation bar
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(user.email),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: EmailScreen(initialEmail: user.email),
                            withNavBar:
                                false, // Hides the bottom navigation bar
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                      const Divider(),

                      // Account Settings Section
                      const ListTile(
                        title: Text('Account Settings',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.place),
                        title: const Text('My Addresses'),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const AddressesScreen(),
                            withNavBar:
                                false, // Hides the bottom navigation bar
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Change Password'),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const ChangePasswordScreen(),
                            withNavBar:
                                false, // Hides the bottom navigation bar
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.security),
                        title: const Text('Privacy & Security'),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const PrivacyAndSecurityScreen(),
                            withNavBar:
                                false, // Hides the bottom navigation bar
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                      const Divider(),

                      // Support and Logout
                      const ListTile(
                        title: Text('Support & Feedback',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Help & Support'),
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const HelpAndSupportScreen(),
                            withNavBar:
                                false, // Hides the bottom navigation bar
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                      const Divider(),

                      // Logout
                      ListTile(
                        leading: const Icon(Icons.logout,
                            color: AppColors.mainColor),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: AppColors.mainColor),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Sign Out'),
                                content: const Text(
                                    'Are you sure you want to sign out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AuthenticationScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      'Sign Out',
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
