import 'dart:async';

import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Delete Account Dialog
  void showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int remainingTime = 3; // Start countdown from 3 seconds
        bool isButtonEnabled = false; // Initially disabled
        Timer? countdownTimer; // Timer reference

        return StatefulBuilder(
          builder: (context, setModalState) {
            // Start the timer only once when the dialog opens
            countdownTimer ??= Timer.periodic(Duration(seconds: 1), (timer) {
              if (remainingTime > 1) {
                setModalState(() {
                  remainingTime--;
                });
              } else {
                timer.cancel();
                countdownTimer = null;
                setModalState(() {
                  isButtonEnabled = true;
                });
              }
            });

            return AlertDialog(
              title: Text('Are you sure you want to delete your account?'),
              content: Text('You cannot undo this action.'),
              actions: [
                // Cancel Button
                MaterialButton(
                  onPressed: () {
                    countdownTimer?.cancel(); // Stop timer if dialog is closed
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(100),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text('Cancel'),
                  ),
                ),

                // Yes Button with Countdown
                MaterialButton(
                  onPressed: isButtonEnabled
                      ? () async {
                          countdownTimer?.cancel();
                          Navigator.of(context).pop();

                          // await AuthService().deleteAccount();
                        }
                      : null,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(100),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(isButtonEnabled ? 'Yes' : '$remainingTime s'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Text('S E T T I N G S'),
        centerTitle: true,
      ),

      // Body
      body: SafeArea(
        child: Column(
          children: [

            // Edit User Settings
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 75,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Center(
                  child: Text('E D I T   P R O F I L E'),
                ),
              ),
            ),

            // Log Out
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();

                await AuthService().signOut();
              },
              child: Container(
                height: 75,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Center(
                  child: Text('L O G   O U T'),
                ),
              ),
            ),

            // Delete Account
            GestureDetector(
              onTap: () => showDeleteAccountDialog(),
              child: Container(
                height: 75,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Center(
                  child: Text('D E L E T E   A C C O U N T'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
