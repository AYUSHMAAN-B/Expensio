import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/pot.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';

class DatabaseService {
  final _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*
  
  E X P E N S E S

  */

  // Add Expense
  Future<void> addExpenseInFirestore(
    String name,
    String desc,
    double amount,
    ExpenseType type,
    String? categoryId,
    DateTime datetime,
  ) async {
    try {
      // Get the userId
      final userId = _auth.getCurrentUser()!.uid;

      Expense newExpense;

      if (categoryId == null) {
        newExpense = Expense(
          id: '',
          name: name,
          desc: desc,
          amount: amount,
          categoryId: null,
          categoryName: null,
          categoryColor: null,
          type: type,
          datetime: datetime,
        );
      } else {
        // Get Category details
        final categoryDoc = await _firestore
            .collection('users')
            .doc(userId)
            .collection('categories')
            .doc(categoryId)
            .get();

        final categoryData = Category.fromDocument(categoryDoc);

        // Create new Expense
        newExpense = Expense(
          id: '',
          name: name,
          desc: desc,
          amount: amount,
          categoryId: categoryId,
          categoryName: categoryData.name,
          categoryColor: categoryData.color,
          type: type,
          datetime: datetime,
        );
      }

      // Add the expense to the firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .add(newExpense.toMap());
    }

    // Catch the error
    catch (e) {
      print('addExpenseInFirestore :=> \n$e');
    }
  }

  // Fetch All Expenses
  Future<List<Expense>> fetchAllExpensesFromFirestore() async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      final expenseSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .get();

      return expenseSnapshot.docs
          .map((doc) => Expense.fromDocument(doc))
          .toList();
    }

    // Return empty list
    catch (e) {
      print('fetchAllExpensesFromFirestore :=> \n$e');
      return [];
    }
  }

  // Change Category of an Expense
  Future<void> changeCategoryInFirestore(
    String expenseId,
    String categoryId,
  ) async {
    try {
      // Get userID
      final userId = _auth.getCurrentUser()!.uid;

      // Get Category details
      final categoryDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(categoryId)
          .get();

      final categoryData = Category.fromDocument(categoryDoc);

      // Update Expense
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expenseId)
          .update({
        'categoryId': categoryId,
        'categoryName': categoryData.name,
        'categoryColor': categoryData.color,
      });
    }

    // Catch error
    catch (e) {
      print('changeCategoryInFirestore :=> \n$e');
    }
  }

  // Edit Expense
  Future<void> editExpenseInFirestore(
    String expenseId,
    String name,
    double amount,
    String desc,
    ExpenseType type,
  ) async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      // Update Expense
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expenseId)
          .update(
        {
          'name': name,
          'amount': amount,
          'desc': desc,
          'type': type.toString(),
        },
      );
    }

    // Catch error
    catch (e) {
      print('editExpenseInFirestore :=> \n$e');
    }
  }

  // Delete Expense
  Future<void> deleteExpenseInFirestore(String expenseId) async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      // Delete in firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    }

    // Catch
    catch (e) {
      print('deleteExpenseInFirestore :=> \n$e');
    }
  }

  /*
  
  C A T E G O R I E S

  */

  // Add Category
  Future<void> addCategoryInFirestore(String name, Color? color) async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      // Create new Category
      Category newCategory = Category(
        id: '',
        name: name,
        color: color,
      );

      // Add category to firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .add(newCategory.toMap());
    }

    // Catch error
    catch (e) {
      print(e);
    }
  }

  // Fetch All Categories
  Future<List<Category>> fetchAllCategoriesFromFirestore() async {
    try {
      // Get userId
      final userId = _auth.getCurrentUser()!.uid;

      final categorySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .get();

      return categorySnapshot.docs
          .map((doc) => Category.fromDocument(doc))
          .toList();
    }

    // Return empty list on error
    catch (e) {
      print('fetchAllCategoriesFromFirestore :=> \n$e');
      return [];
    }
  }

  // Edit Category
  Future<void> editCategoryInFirestore(
    String categoryId,
    String name,
    Color? color,
  ) async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      // Edit category in firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(categoryId)
          .update({
        'name': name,
        'color': color,
      });
    }

    // Catch error
    catch (e) {
      print('editCategoryInFirestore :=> \n$e');
    }
  }

  // Delete Category
  Future<void> deleteCategoryInFirestore(String categoryId) async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      // Delete category in firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(categoryId)
          .delete();
    }

    // Catch error
    catch (e) {
      print('deleteCategoryInFirestore :=> \n$e');
    }
  }

  /*
  
  POTS

  */

  // Add Pot
  Future<void> addPotInFirestore(String name, double goal) async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      // Create new Pot
      Pot newPot = Pot(
        id: '',
        name: name,
        goal: goal,
        sofar: 0.0,
      );

      // Add Pot to firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('pots')
          .add(newPot.toMap());
    }

    // Catch error
    catch (e) {
      print('addPotInFirestore :=> \n$e');
    }
  }

  // Fetch All Pots
  Future<List<Pot>> fetchAllPotsFromFirestore() async {
    try {
      // Get userId
      final userId = _auth.getCurrentUser()!.uid;

      final potSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('pots')
          .get();

      return potSnapshot.docs.map((doc) => Pot.fromDocument(doc)).toList();
    }

    // Return empty list on error
    catch (e) {
      print('fetchAllPotsFromFirestore :=> \n$e');
      return [];
    }
  }

  // Edit Pot
  Future<void> editPotInFirestore(
    String potId,
    String name,
    double goal,
    double sofar,
  ) async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      // Edit Pot in firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('pots')
          .doc(potId)
          .update({
        'name': name,
        'goal': goal,
        'sofar': sofar,
      });
    }

    // Catch error
    catch (e) {
      print('editPotInFirestore :=> \n$e');
    }
  }

  // Delete Pot
  Future<void> deletePotInFirestore(String potId) async {
    try {
      // Get useId
      final userId = _auth.getCurrentUser()!.uid;

      // Delete pot in firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('pots')
          .doc(potId)
          .delete();
    }

    // Catch error
    catch (e) {
      print('deletePotInFirestore :=> \n$e');
    }
  }
}
