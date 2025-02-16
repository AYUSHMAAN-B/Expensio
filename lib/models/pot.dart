import 'package:cloud_firestore/cloud_firestore.dart';

class Pot {
  final String id;
  final String name;
  final double goal;
  final double sofar;

  Pot({
    required this.id,
    required this.name,
    required this.goal,
    required this.sofar,
  });

  factory Pot.fromDocument(DocumentSnapshot doc) {
    return Pot(
      id: doc.id,
      name: doc['name'],
      goal: doc['goal'] as double,
      sofar: doc['sofar'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'goal': goal,
      'sofar': sofar,
    };
  }
}
