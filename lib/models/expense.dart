// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String name;
  final String desc;
  final double amount;
  final String? categoryId;
  final String? categoryName;
  final Color? categoryColor;
  final ExpenseType type;
  final DateTime datetime;

  Expense({
    required this.id,
    required this.name,
    required this.desc,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
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
      categoryName: doc['categoryName'],
      categoryColor: doc['categoryColor'],
      type: ExpenseType.values.firstWhere((e) => e.toString() == doc['type']),
      datetime: (doc['datetime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'amount': amount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryColor': categoryColor,
      'type': type.toString(),
      'datetime': datetime,
    };
  }
}

enum ExpenseType { Income, Expense }
