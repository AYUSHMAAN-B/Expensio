import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/pots_page.dart';
import 'package:expense_tracker/pages/profile_page.dart';
import 'package:expense_tracker/pages/stats_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    PotsPage(),
    StatsPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Bottom Navigation Bar
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        animationDuration: Duration(milliseconds: 250),
        color: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_outlined,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            label: 'Home',
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.savings,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            label: 'Pots',
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.stacked_line_chart_rounded,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            label: 'Stats',
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            label: 'Profile',
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
      
      // Body
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
