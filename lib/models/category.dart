import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final Color? color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Category.fromDocument(DocumentSnapshot doc) {
    return Category(
      id: doc.id,
      name: doc['name'],
      color: doc['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}
