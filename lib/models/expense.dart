// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String name;
  final String desc;
  final double amount;
  final String? categoryId;
  final ExpenseType type;
  final DateTime datetime;

  Expense({
    required this.id,
    required this.name,
    required this.desc,
    required this.amount,
    required this.categoryId,
    required this.type,
    required this.datetime,
  });

  factory Expense.fromDocument(DocumentSnapshot doc) {
    return Expense(
      id: doc.id,
      name: doc['name'],
      desc: doc['desc'],
      amount: doc['amount'],
      categoryId: doc['categoryId'],
      type: doc['type'],
      datetime: doc['datetime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'amount': amount,
      'categoryId': categoryId,
      'type': type,
      'datetime': datetime,
    };
  }
}

enum ExpenseType { Income, Expense }
