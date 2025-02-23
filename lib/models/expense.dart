// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String name;
  final String desc;
  final double amount;
  String? categoryId;
  String? categoryName;
  Color? categoryColor;
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
    Map<String, dynamic>? colorData = doc['categoryColor'];

    return Expense(
      id: doc.id,
      name: doc['name'],
      desc: doc['desc'],
      amount: doc['amount'],
      categoryId: doc['categoryId'],
      categoryName: doc['categoryName'],
      categoryColor: colorData != null
          ? Color.fromARGB(
              (colorData['a'] as num).toInt(),
              (colorData['r'] as num).toInt(),
              (colorData['g'] as num).toInt(),
              (colorData['b'] as num).toInt(),
            )
          : null,
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
      'categoryColor': categoryColor != null
          ? {
              'a': (categoryColor!.a * 255).toInt(),
              'r': (categoryColor!.r * 255).toInt(),
              'g': (categoryColor!.g * 255).toInt(),
              'b': (categoryColor!.b * 255).toInt(),
            }
          : null,
      'type': type.toString(),
      'datetime': datetime,
    };
  }
}

enum ExpenseType { Income, Expense }
