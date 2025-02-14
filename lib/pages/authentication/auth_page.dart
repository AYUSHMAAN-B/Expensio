import 'package:expense_tracker/pages/authentication/signin_page.dart';
import 'package:expense_tracker/pages/authentication/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLoggedIn = true;

  void toggleScreens() {
    setState(() {
      isLoggedIn = !isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if( isLoggedIn ) {
      return SigninPage(onTap: toggleScreens);
    } else {
      return SignupPage(onTap: toggleScreens);
    }
  }
}