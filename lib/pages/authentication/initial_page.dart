import 'package:expense_tracker/pages/authentication/auth_page.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if( snapshot.hasData ) {
            return HomePage();
          } else {
            return AuthPage();
          }
        }
      ),
    );
  }
}