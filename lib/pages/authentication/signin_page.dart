// ignore_for_file: use_build_context_synchronously

import 'package:expense_tracker/components/my_text_field.dart';
import 'package:expense_tracker/pages/authentication/forget_password_page.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SigninPage extends StatefulWidget {
  final VoidCallback onTap;

  const SigninPage({super.key, required this.onTap});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final AuthService auth = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          );
        },
        barrierDismissible: false);

    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        // Sign In With Email and Password
        await auth.signInWithEmailAndPassword(
            emailController.text, passwordController.text);

        // Pop the dialog
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Pop the dialog
      if (mounted) Navigator.of(context).pop();

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> googleSignIn() async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        );
      },
      barrierDismissible: false,
    );

    try {
      await auth.signInUsingGoogle();
      if (!mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16.0,
                children: [
                  const SizedBox(height: 35),

                  // Lottie Icon
                  Lottie.asset('assets/intro.json'),

                  // Welcome Text
                  Text(
                    'Welcome to Twitter (X) Clone',
                    style: GoogleFonts.dmSerifText(
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Email
                  MyTextField(
                    controller: emailController,
                    icon: Icons.email,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  // Password
                  MyTextField(
                    controller: passwordController,
                    icon: Icons.key,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  // Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // SignIn Button
                  GestureDetector(
                    onTap: signIn,
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 64.0),
                      color: Theme.of(context).colorScheme.tertiary,
                      elevation: 12.0,
                      shadowColor: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // const SizedBox(height: 25),

                  // OR
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          indent: 10,
                          endIndent: 10,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text('OR'),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          indent: 10,
                          endIndent: 10,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),

                  // Google SignIn Text
                  Text(
                    'Sign In using Google',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  // const SizedBox(height: 25),

                  // SignIn Using Google
                  GestureDetector(
                    onTap: googleSignIn,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(75)),
                      child: Image.asset(
                        'assets/google.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Not a Member Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member? ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
