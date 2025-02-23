import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Category.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> colorData = doc['color'];

    return Category(
      id: doc.id,
      name: doc['name'],
      color: Color.fromARGB(
        (colorData['a'] as num).toInt(),
        (colorData['r'] as num).toInt(),
        (colorData['g'] as num).toInt(),
        (colorData['b'] as num).toInt(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': {
        'a': (color.a * 255).toInt(),
        'r': (color.r * 255).toInt(),
        'g': (color.g * 255).toInt(),
        'b': (color.b * 255).toInt(),
      },
    };
  }
}
