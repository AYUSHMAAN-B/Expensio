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
    // Fetch Expenses
    _allExpenses = await _db.fetchAllExpensesFromFirestore();

    // Update UI
    notifyListeners();
  }

  // Get Expense By Id
  Expense getExpenseById(String expenseId) {
    return _allExpenses.where((expense) => expense.id == expenseId).toList()[0];
  }

  // Add Expense
  Future<void> addExpense(
    String name,
    String desc,
    double amount,
    ExpenseType type,
    String? categoryId,
    DateTime datetime,
  ) async {
    // Create new Expense
    Expense newExpense = Expense(
      id: '',
      name: name,
      desc: desc,
      amount: amount,
      categoryId: categoryId,
      categoryName: null,
      categoryColor: null,
      type: type,
      datetime: datetime,
    );

    // Add to local storage
    _allExpenses.add(newExpense);

    // Update UI
    notifyListeners();

    // Add Expense in Firestore
    await _db.addExpenseInFirestore(
        name, desc, amount, type, categoryId, datetime);

    // Update Local Storage
    await fetchExpenses();
  }

  // Edit Expense
  Future<void> editExpense(
    String expenseId,
    String name,
    double amount,
    String desc,
    ExpenseType type,
  ) async {
    // Get the current expense
    final currentExpense =
        _allExpenses.where((expense) => expense.id == expenseId).toList()[0];

    final updatedExpense = Expense(
      id: currentExpense.id,
      name: name,
      desc: desc,
      amount: amount,
      categoryId: currentExpense.categoryId,
      categoryName: currentExpense.categoryName,
      categoryColor: currentExpense.categoryColor,
      type: type,
      datetime: currentExpense.datetime,
    );

    // Replace current expense with updated expense
    _allExpenses.remove(currentExpense);
    _allExpenses.add(updatedExpense);

    // Update UI
    notifyListeners();

    // Edit Expense in Firestore
    await _db.editExpenseInFirestore(expenseId, name, amount, desc, type);
  }

  // Delete Expense
  Future<void> deleteExpense(String expenseId) async {
    // Get the current expense
    final currentExpense =
        _allExpenses.where((expense) => expense.id == expenseId).toList()[0];

    // Delete the expense from local storage
    _allExpenses.remove(currentExpense);

    // Update UI
    notifyListeners();

    // Delete Expense in Firestore
    await _db.deleteExpenseInFirestore(expenseId);
  }

  // Change Expense Category
  Future<void> changeExpenseCategory(
    String expenseId,
    String categoryId,
  ) async {
    // Find the category
    final category =
        _allCategories.where((category) => category.id == categoryId).first;

    // Find the expense
    final expense =
        _allExpenses.where((expense) => expense.id == expenseId).first;

    // Remove the expense
    _allExpenses.remove(expense);

    // Update the expense
    expense.categoryId = category.id;
    expense.categoryName = category.name;
    expense.categoryColor = category.color;

    // Add the expense
    _allExpenses.add(expense);

    // Update UI
    notifyListeners();

    // Change Expense Category in Firestore
    await _db.changeCategoryInFirestore(expenseId, categoryId);

    // Update Local Storage
    await fetchExpenses();

    // Update Expense Category Map
    initializeExpenseCategoryMap();
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
              (expense.type == ExpenseType.Expense) &&
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
              (expense.type == ExpenseType.Expense) &&
              (expense.datetime.month == selectedTime.month) &&
              (expense.datetime.year == selectedTime.year))
          .toList();

  // Get Expenses For Year
  List<Expense> getExpensesForYear(
    int year,
    DateTime selectedTime,
  ) =>
      _allExpenses
          .where((expense) =>
              (expense.type == ExpenseType.Expense) &&
              (expense.datetime.year == selectedTime.year))
          .toList();

  // Get Incomes For Day
  List<Expense> getIncomesForDay(
    int day,
    int month,
    int year,
    DateTime selectedTime,
  ) =>
      _allExpenses
          .where((expense) =>
              (expense.type == ExpenseType.Income) &&
              (expense.datetime.day == selectedTime.day) &&
              (expense.datetime.month == selectedTime.month) &&
              (expense.datetime.year == selectedTime.year))
          .toList();

  // Get Incomes For Month
  List<Expense> getIncomesForMonth(
    int month,
    int year,
    DateTime selectedTime,
  ) =>
      _allExpenses
          .where((expense) =>
              (expense.type == ExpenseType.Income) &&
              (expense.datetime.month == selectedTime.month) &&
              (expense.datetime.year == selectedTime.year))
          .toList();

  // Get Incomes For Year
  List<Expense> getIncomesForYear(
    int year,
    DateTime selectedTime,
  ) =>
      _allExpenses
          .where((expense) =>
              (expense.type == ExpenseType.Income) &&
              (expense.datetime.year == selectedTime.year))
          .toList();

  // Get Expenses For Custom Range
  List<Expense> getExpensesForRange(DateTime fromDate, DateTime tillDate) {
    return _allExpenses
        .where((expense) =>
            (expense.type == ExpenseType.Expense) &&
            expense.datetime.isAfter(fromDate.subtract(Duration(days: 1))) &&
            expense.datetime.isBefore(tillDate.add(Duration(days: 1))))
        .toList();
  }

  // Get Incomes For Custom Range
  List<Expense> getIncomesForRange(DateTime fromDate, DateTime tillDate) {
    return _allExpenses
        .where((expense) =>
            (expense.type == ExpenseType.Income) &&
            expense.datetime.isAfter(fromDate.subtract(Duration(days: 1))) &&
            expense.datetime.isBefore(tillDate.add(Duration(days: 1))))
        .toList();
  }

  /*
  
  C A T E G O R I E S

  */

  List<Category> _allCategories = [];
  List<Category> get allCategories => _allCategories;

  final Map<String, List<Expense>> _expenseCategoryMap = {};
  Map<String, List<Expense>> get expenseCategoryMap => _expenseCategoryMap;

  // Initialize Expense Category Map
  void initializeExpenseCategoryMap() {
    _expenseCategoryMap.clear();

    for (var expense in _allExpenses) {
      String? category = expense.categoryId;

      if (category == null) {
        continue;
      }

      if (!_expenseCategoryMap.containsKey(category)) {
        _expenseCategoryMap[category] = [];
      }

      _expenseCategoryMap[category]!.add(expense);
    }
  }

  // Add Category
  Future<void> addCategory(String name, Color color) async {
    // Create a temp new Category
    Category newCategory = Category(
      id: '',
      name: name,
      color: color,
    );

    // Add to local storage
    _allCategories.add(newCategory);

    // Update UI
    notifyListeners();

    // Add Category In Firestore
    await _db.addCategoryInFirestore(name, color);

    // Update Local Storage
    await fetchCategories();
  }

  // Edit Category
  Future<void> editCategory(
    String categoryId,
    String name,
    Color color,
  ) async {
    Category updatedCategory = Category(
      id: categoryId,
      name: name,
      color: color,
    );

    // Find the current Category index
    int index =
        _allCategories.indexWhere((category) => category.id == categoryId);

    // Remove tehe current Category
    _allCategories.removeAt(index);

    // Add the updated Category
    _allCategories.add(updatedCategory);

    // Update UI
    notifyListeners();

    // Edit Category In Firestore
    await _db.editCategoryInFirestore(categoryId, name, color);

    // Update Local Storage
    await fetchCategories();
  }

  // Delete Category
  Future<void> deleteCategory(String categoryId) async {
    // Find the current Category index
    int index =
        _allCategories.indexWhere((category) => category.id == categoryId);

    // Remove tehe current Category
    _allCategories.removeAt(index);

    // Update UI
    notifyListeners();

    // Delete Category In Firestore
    await _db.deleteCategoryInFirestore(categoryId);

    // Update Local Storage
    await fetchCategories();
  }

  // Fetch All Categories
  Future<void> fetchCategories() async {
    // Fetch Categories
    _allCategories = await _db.fetchAllCategoriesFromFirestore();

    // Update UI
    notifyListeners();
  }

  /*
  
  P O T S

  */

  List<Pot> _allPots = [];

  List<Pot> get allPots => _allPots;

  // Add Pot
  Future<void> addPot(String name, int goal, String iconPath) async {
    // Add Pot In Firestore
    await _db.addPotInFirestore(name, goal, iconPath);

    // Update Local Storage
    await fetchPots();
  }

  // Edit Pot
  Future<void> editPot(
    String potId,
    String name,
    double goal,
    String iconPath,
  ) async {
    // Edit Pot In Firestore
    await _db.editPotInFirestore(potId, name, goal, iconPath);

    // Update Local Storage
    await fetchPots();
  }

  // Edit SoFar In Pot
  Future<void> editSoFarInPot(String potId, double sofar) async {
    // Edit SoFar In Pot In Firestore
    await _db.editSoFarInPotInFirestore(potId, sofar);

    // Update Local Storage
    await fetchPots();
  }

  // Delete Pot
  Future<void> deletePot(String potId) async {
    // Delete Pot In Firestore
    await _db.deletePotInFirestore(potId);

    // Update Local Storage
    await fetchPots();
  }

  // Fetch All Pots
  Future<void> fetchPots() async {
    // Fetch Pots
    _allPots = await _db.fetchAllPotsFromFirestore();

    // Update UI
    notifyListeners();
  }


  /*
  
  U S E R
  
  */

  // Update User Profile
  Future<void> updateUserProfile(String newName) async {
    // Update in Firestore
    await _db.updateUserProfileInFirestore(newName);
  }

  // Update Password
  Future<void> updatePassword(String newPassword) async {
    // Update in Firestore
    await _db.updatePasswordInFirestore(newPassword);
  }
}
