import 'package:cloud_firestore/cloud_firestore.dart';

class Pot {
  final String id;
  final String name;
  final int goal;
  final int sofar;
  final String? iconPath;

  Pot({
    required this.id,
    required this.name,
    required this.goal,
    required this.sofar,
    required this.iconPath,
  });

  factory Pot.fromDocument(DocumentSnapshot doc) {
    return Pot(
      id: doc.id,
      name: doc['name'],
      goal: (doc['goal'] as num).toInt(),
      sofar: (doc['sofar'] as num).toInt(),
      iconPath: doc['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'goal': goal,
      'sofar': sofar,
      'imagePath': iconPath,
    };
  }
}
