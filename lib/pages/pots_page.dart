import 'package:flutter/material.dart';

class PotsPage extends StatefulWidget {
  const PotsPage({super.key});

  @override
  State<PotsPage> createState() => _PotsPageState();
}

class _PotsPageState extends State<PotsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Text('Pots Page'),
        centerTitle: true,
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
