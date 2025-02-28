// ignore_for_file: use_build_context_synchronously

import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/pages/category_expenses_page.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:expense_tracker/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // Category Controller
  final categoryController = TextEditingController();

  // Selected Color
  Color selectedColor = Colors.transparent;

  UserProfile? user;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    await databaseProvider.fetchCategories();
    user = await AuthService().getCurrentUserInfo();
    setState(() {});
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  // Add / Edit Category Dilog
  void showCategoryDailog({bool edit = false, String? categoryId}) {
    showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return AlertDialog(
              title: Text('Add Your Custom Category'),
              content: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TextField
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        hintText: 'Category',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Color Picker inside ScrollView
                    SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                // Cancel
                TextButton(
                  onPressed: () {
                    categoryController.clear();
                    selectedColor = Colors.transparent;
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),

                // Add
                TextButton(
                  onPressed: () async {
                    if (categoryController.text.isNotEmpty) {
                      // Pop the dialog
                      if (mounted) Navigator.of(context).pop();

                      if (edit) {
                        // Edit the category in the firestore
                        await databaseProvider.editCategory(
                          categoryId!,
                          categoryController.text,
                          selectedColor,
                        );
                      } else {
                        // Add the category in the firestore
                        await databaseProvider.addCategory(
                          categoryController.text,
                          selectedColor,
                        );
                      }

                      // clear the controller
                      categoryController.clear();

                      // revert the selected color
                      selectedColor = Colors.transparent;
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Delete Category Dialog
  void showDeleteDialog({required String categoryId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to delete this category ?'),
          actions: [
            // Cancel
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),

            // Add
            TextButton(
              onPressed: () async {
                // Pop the dialog
                if (mounted) Navigator.of(context).pop();

                await databaseProvider.deleteCategory(categoryId);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Format Amount
  String formatIndianCurrency(int amount) {
    if (amount >= 10000000) {
      return "${(amount / 10000000).toStringAsFixed(2)} Cr";
    } else if (amount >= 100000) {
      return "₹ ${(amount / 100000).toStringAsFixed(2)} L";
    } else {
      final formatter = NumberFormat.currency(
          locale: "en_IN", symbol: "₹ ", decimalDigits: 0);
      return formatter.format(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get Date
    String monthName = DateFormat('MMM').format(DateTime.now());
    int month = DateTime.now().month;
    int year = DateTime.now().year;

    double totalIncome;
    double totalExpense;

    final allIncomes =
        listeningProvider.getIncomesForMonth(month, year, DateTime.now());
    final allExpenses =
        listeningProvider.getExpensesForMonth(month, year, DateTime.now());

    totalIncome = allIncomes.fold(0.0, (sum, expense) => sum + expense.amount);
    totalExpense =
        allExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

    final categories = listeningProvider.allCategories;

    return Scaffold(
      // Background color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // body
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hello Welcome Text
              Stack(
                children: [
                  // Name and Photo
                  Container(
                    height: 250,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              Text(
                                user == null ? '' : user!.name,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 56,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 220.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32)),
                    ),
                  ),

                  // Summary Card
                  Container(
                    height: 200,
                    margin: EdgeInsets.only(
                        top: 125.0, bottom: 16.0, left: 16.0, right: 16.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          blurRadius: 5,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${formatIndianCurrency((totalIncome - totalExpense).toInt())} /-',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Balance',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '${formatIndianCurrency(totalIncome.toInt())} /-',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Total Income ($monthName)',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '${formatIndianCurrency(totalExpense.toInt())} /-',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Total Expense ($monthName)',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Categories with add button
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('CATEGORIES'),
                    IconButton(
                      onPressed: showCategoryDailog,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ),

              // List<Category>
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  // Extract each category
                  final category = categories[index];

                  return Slidable(
                    endActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Pre fill the name and color
                            categoryController.text = category.name;
                            selectedColor = category.color;

                            // showDialog
                            showCategoryDailog(
                              edit: true,
                              categoryId: category.id,
                            );
                          },
                          backgroundColor: Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        SlidableAction(
                          onPressed: (context) =>
                              showDeleteDialog(categoryId: category.id),
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CategoryExpensesPage(
                                categoryId: category.id,
                                categoryName: category.name,
                              ))),
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Category Symbol
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    color: category.color,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category.name[0],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Category Name
                                Text(category.name)
                              ],
                            ),
                            Icon(Icons.keyboard_arrow_right_outlined),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
