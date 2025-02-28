// ignore_for_file: use_build_context_synchronously

import 'package:expense_tracker/components/my_text_field.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:expense_tracker/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // Controllers
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  UserProfile? user;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  void getUserProfile() async {
    user = await AuthService().getCurrentUserInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = user == null ? '' : user!.name;

    // Originals
    String hasNameChanged = nameController.text;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Ensures scrolling when keyboard appears
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'User Profile',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            SizedBox(width: 100, child: Text('Name')),
                            Expanded(
                              child: MyTextField(
                                controller: nameController,
                                icon: null,
                                hintText: 'Enter your name',
                                obscureText: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Divider(thickness: 1.2, indent: 16, endIndent: 16),

                    if (AuthService().getCurrentUser()!.photoURL != null) ...[
                      // Change Password Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 130, child: Text('New Password')),
                                  Expanded(
                                    child: MyTextField(
                                      controller: passwordController,
                                      icon: null,
                                      hintText: 'Enter new password',
                                      obscureText: true,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(thickness: 1.0),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 130,
                                      child: Text('Confirm Password')),
                                  Expanded(
                                    child: MyTextField(
                                      controller: confirmPasswordController,
                                      icon: null,
                                      hintText: 'Confirm new password',
                                      obscureText: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),

            // Save Info Button
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () async {
                    if (passwordController.text.isNotEmpty &&
                        confirmPasswordController.text.isNotEmpty) {
                      if (passwordController.text ==
                          confirmPasswordController.text) {
                        await databaseProvider
                            .updatePassword(passwordController.text);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords Do Not Match')),
                        );
                      }
                    } else {
                      Navigator.of(context).pop();
                    }

                    if (hasNameChanged != nameController.text) {
                      await databaseProvider
                          .updateUserProfile(nameController.text);
                    }
                  },
                  child: Container(
                    height: 75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(100),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Center(
                      child: Text(
                        'S A V E   I N F O R M A T I O N',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
