import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/pot.dart';
import 'package:expense_tracker/services/database/database_service.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();

  /*
  
  E X P E N S E S

  */

  List<Expense> _allExpenses = [];

  List<Expense> get allExpenses => _allExpenses;

  // Fetch All Expenses
  Future<void> fetchExpenses() async {
    _allExpenses = await _db.fetchAllExpensesFromFirestore();
  }

  // Get Expenses For Day
  List<Expense> getExpensesForDay(
    int day,
    int month,
    int year,
    DateTime selectedTime,
  ) =>
      _allExpenses
          .where((expense) =>
              (expense.datetime.day == selectedTime.day) &&
              (expense.datetime.month == selectedTime.month) &&
              (expense.datetime.year == selectedTime.year))
          .toList();

  // Get Expenses For Month
  List<Expense> getExpensesForMonth(
    int month,
    int year,
    DateTime selectedTime,
  ) =>
      _allExpenses
          .where((expense) =>
              (expense.datetime.month == selectedTime.month) &&
              (expense.datetime.year == selectedTime.year))
          .toList();

  // Get Expenses For Year
  List<Expense> getExpensesForYear(
    int year,
    DateTime selectedTime,
  ) =>
      _allExpenses
          .where((expense) => (expense.datetime.year == selectedTime.year))
          .toList();

  /*
  
  C A T E G O R I E S

  */

  List<Category> _allCategories = [];
  final Map<String, Category> _expensesCategory = {};
  
  List<Category> get allCategories => _allCategories;
  Map<String, Category> get expensesCategory => _expensesCategory;

  void initializeExpenseCategoryMap() {
    for(var expense in _allExpenses) {
      final category = _allCategories.where((category) => category.id == expense.categoryId).toList();
      _expensesCategory.clear();
      _expensesCategory[expense.id] = category.first;
    }
  }

  // Fetch All Categories
  Future<void> fetchCategories() async {
    _allCategories = await _db.fetchAllCategoriesFromFirestore();
  }

  /*
  
  POTS

  */

  List<Pot> _allPots = [];
  
  List<Pot> get allPots => _allPots;

  // Fetch All Pots
  Future<void> fetchPots() async {
    _allPots = await _db.fetchAllPotsFromFirestore();
  }
}
