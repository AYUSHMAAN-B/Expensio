import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 68),

              // Drawer Header
              Icon(
                Icons.person,
                size: 88,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 35),

              Divider(
                height: 2,
                color: Theme.of(context).colorScheme.secondary,
                indent: 25,
                endIndent: 25,
              ),

              const SizedBox(height: 35),

              // Home
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 16.0),
                  child: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  'H O M E',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

              // Profile
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 16.0),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  'P R O F I L E',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

              // Settings
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 16.0),
                  child: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  'S E T T I N G S',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

          // LogOut
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 16.0),
                child: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                'L O G   O U T',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
