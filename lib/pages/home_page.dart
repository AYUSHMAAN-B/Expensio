// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:expense_tracker/components/daily_expense_card.dart';
import 'package:expense_tracker/components/my_drawer.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Tab Controller
  late final tabController;

  // Controllers
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final descController = TextEditingController();

  // Selected Date
  DateTime selectedDate = DateTime.now();

  // Selected Expense
  String? selectedExpenseId;

  // Selected Expense Type
  ExpenseType selectedExpenseType = ExpenseType.Expense;

  // Providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    await databaseProvider.fetchExpenses();
    databaseProvider.initializeExpenseCategoryMap();
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Add Expense Dialog
  void addExpenseDialog({bool edit = false}) {
    if (edit == true) {
      final expense = databaseProvider.getExpenseById(selectedExpenseId!);

      nameController.text = expense.name;
      amountController.text = expense.amount.toString();
      descController.text = expense.desc;
      selectedExpenseType = expense.type;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Wrap(
                  children: [
                    // Income [OR] Expense Toggle
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Income Box
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  // Updates only modal state
                                  selectedExpenseType = ExpenseType.Income;
                                });
                              },
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: (selectedExpenseType ==
                                          ExpenseType.Income)
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(16)),
                                ),
                                child: Center(
                                  child: Text(
                                    'Income',
                                    style: TextStyle(
                                      color: (selectedExpenseType ==
                                              ExpenseType.Income)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Expense Box
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedExpenseType = ExpenseType.Expense;
                                });
                              },
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: (selectedExpenseType ==
                                          ExpenseType.Expense)
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.surface,
                                  border: Border(
                                    top: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    right: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(16)),
                                ),
                                child: Center(
                                  child: Text(
                                    'Expense',
                                    style: TextStyle(
                                      color: (selectedExpenseType ==
                                              ExpenseType.Expense)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Expense Information
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Categories Icon
                          GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.category),
                          ),

                          // Name TextField
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(left: 4.0),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary)),
                              ),
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          // Amount Text Field
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 4.0),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary)),
                              ),
                              child: TextField(
                                controller: amountController,
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.numberWithOptions(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Description TextField
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.description),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              controller: descController,
                              decoration: InputDecoration(
                                hintText: 'Description',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Save Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () {
                              if (nameController.text.isNotEmpty &&
                                  amountController.text.isNotEmpty) {
                                // Pop the bottom sheet
                                Navigator.of(context).pop();

                                if (edit == true) {
                                  // Add the expense in db
                                  databaseProvider.editExpense(
                                    selectedExpenseId!,
                                    nameController.text,
                                    double.parse(amountController.text),
                                    descController.text,
                                    selectedExpenseType,
                                  );

                                  // Revert the selected to null
                                  selectedExpenseId = null;
                                } else {
                                  // Add the expense in db
                                  databaseProvider.addExpense(
                                    nameController.text,
                                    descController.text,
                                    double.parse(amountController.text),
                                    selectedExpenseType,
                                    null,
                                    selectedDate,
                                  );
                                }

                                // Clear the controllers
                                nameController.clear();
                                amountController.clear();
                                descController.clear();
                              }
                            },
                            icon: Icon(
                              Icons.done,
                              size: 32.0,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Delete Expense Dialog
  void deleteExpenseDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete This Record?'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              // Cancel
              MaterialButton(
                onPressed: () async {
                  // Pop the dialog
                  Navigator.of(context).pop();

                  // Revert the selection
                  setState(() {
                    selectedExpenseId = null;
                  });
                },
                child: Text('Cancel'),
              ),

              // Yes
              MaterialButton(
                onPressed: () async {
                  // Pop the dialog
                  Navigator.of(context).pop();

                  // Delete the expense
                  await databaseProvider.deleteExpense(selectedExpenseId!);

                  // Revert the selection
                  selectedExpenseId = null;
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  // Expense Category Dialog
  void expenseCategoryDialog() {
    final categories = listeningProvider.allCategories;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose the category'),
          content: Wrap(
            children: categories.map(
              (category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () async {
                      // Pop the dialog
                      Navigator.of(context).pop();

                      final expenseId = selectedExpenseId!;

                      // Revert the selection
                      selectedExpenseId = null;

                      // Change Expense Category
                      await databaseProvider.changeExpenseCategory(
                          expenseId, category.id);
                    },
                    child: Chip(
                      label: Text(category.name),
                      backgroundColor: category.color,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  // To Select Date
  Future<void> showDateSelector() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    setState(() {
      selectedDate = pickedDate ?? DateTime.now();
    });
  }

  // To Select Month
  Future<void> showMonthSelector() async {
    final DateTime? pickedDate = await showMonthPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    if (pickedDate != null) {
      setState(() {
        // Only update the month and year, ignore the day
        selectedDate = DateTime(pickedDate.year, pickedDate.month);
      });
    }
  }

  // To Select Year
  Future<void> showYearSelector() async {
    final int? pickedDate = await showYearPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    if (pickedDate != null) {
      setState(() {
        // Only update the month and year, ignore the day
        selectedDate = DateTime(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allExpenses = listeningProvider.allExpenses;

    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Text('E X P E N S I O'),
        centerTitle: true,
        actions: [
          if (selectedExpenseId != null) ...[
            IconButton(
              onPressed: () => expenseCategoryDialog(),
              icon: Icon(
                Icons.category,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () => addExpenseDialog(edit: true),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () => deleteExpenseDialog(),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),

      // Drawer
      drawer: MyDrawer(),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => addExpenseDialog(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add),
      ),

      // // Bottom Navigation Bar
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: Theme.of(context).colorScheme.surface,
      //   buttonBackgroundColor: Theme.of(context).colorScheme.tertiary,
      //   animationDuration: Duration(milliseconds: 250),
      //   color: Theme.of(context).colorScheme.primary,
      //   onTap: (index) {
      //     if (index == 0) {
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (context) => HomePage()));
      //     } else if (index == 1) {
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (context) => PotsPage()));
      //     } else if (index == 2) {
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (context) => StatsPage()));
      //     }
      //   },
      //   items: [
      //     CurvedNavigationBarItem(
      //       child: Icon(Icons.home_outlined),
      //       label: 'Home',
      //       labelStyle: TextStyle(
      //         color: Theme.of(context).colorScheme.tertiary,
      //       ),
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(Icons.savings),
      //       label: 'Pots',
      //       labelStyle: TextStyle(
      //         color: Theme.of(context).colorScheme.tertiary,
      //       ),
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(Icons.stacked_line_chart_rounded),
      //       label: 'Stats',
      //       labelStyle: TextStyle(
      //         color: Theme.of(context).colorScheme.tertiary,
      //       ),
      //     ),
      //   ],
      // ),

      // Body
      body: SafeArea(
        child: Column(
          children: [
            // Tabs
            TabBar(
              controller: tabController,
              padding: EdgeInsets.all(16.0),
              indicatorColor: Theme.of(context).colorScheme.primary,
              dividerColor: Theme.of(context).colorScheme.secondary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.secondary,
              tabs: [
                Tab(text: 'Day'),
                Tab(text: 'Month'),
                Tab(text: 'Year'),
              ],
            ),

            // Tab Contents
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // Daily Expenses
                  widgetDailyExpenses(allExpenses),

                  // Monthly Expenses
                  widgetMontlyExpenses(allExpenses),

                  // Yearly Expenses
                  widgetYearlyExpenses(allExpenses),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget For Daily Expenses
  Widget widgetDailyExpenses(List<Expense> allExpenses) {
    // Incomes
    final incomes = allExpenses
        .where((expense) =>
            (expense.type == ExpenseType.Income) &&
            isSameDate(expense.datetime, selectedDate))
        .toList();

    final totalIncomeForTheDay =
        incomes.fold(0.0, (sum, expense) => sum + expense.amount);

    // Expenses
    final expenses = allExpenses
        .where((expense) =>
            (expense.type == ExpenseType.Expense) &&
            isSameDate(expense.datetime, selectedDate))
        .toList();

    final totalExpenseForTheDay =
        expenses.fold(0.0, (sum, expense) => sum + expense.amount);

    // Get Day, Month, and Year
    String day = selectedDate.day.toString();
    String month = DateFormat('MMMM').format(selectedDate);
    String year = selectedDate.year.toString();

    // Is selectedDate today?
    bool isToday = DateFormat('dd-MM-yyyy').format(DateTime.now()) ==
        DateFormat('dd-MM-yyyy').format(selectedDate);

    return Column(
      children: [
        // Date Field
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous Date Icon
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = selectedDate.subtract(Duration(days: 1));
                  });
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 36,
                ),
              ),

              // Date
              GestureDetector(
                onTap: () => showDateSelector(),
                child: Row(
                  children: [
                    // Day
                    Container(
                      padding: EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                          border: isToday
                              ? Border(
                                  top: BorderSide(color: Colors.black),
                                  bottom: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )
                              : Border(),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Month
                    Text(
                      month,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Year
                    Text(
                      year,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // Next Date Icon
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = selectedDate.add(Duration(days: 1));
                  });
                },
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 36,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Income Field
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Income (CREDIT)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Text(
                '₹ $totalIncomeForTheDay',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),

        if (incomes.isEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Tap on \'+\' to add new item and long press an entry to edit.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
        ] else
          const SizedBox(height: 4),

        // Display Incomes
        ListView.builder(
          shrinkWrap: true,
          itemCount: incomes.length,
          itemBuilder: (context, index) {
            final income = incomes[index];
            return Padding(
              padding: (index == incomes.length - 1)
                  ? const EdgeInsets.only(bottom: 4.0)
                  : const EdgeInsets.all(0.0),
              child: DailyExpenseCard(
                id: income.id,
                category: income.categoryName,
                name: income.name,
                amount: income.amount,
                onTap: () {
                  setState(() {
                    selectedExpenseId = null;
                  });
                },
                onLongPress: () {
                  setState(() {
                    selectedExpenseId = income.id;
                  });
                },
                selectedExpenseId: selectedExpenseId,
              ),
            );
          },
        ),

        // Expense Field
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expense (DEBIT)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Text(
                '₹ $totalExpenseForTheDay',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),

        if (expenses.isEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Tap on \'+\' to add new item and long press an entry to edit.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ] else
          const SizedBox(height: 4),

        // Display Expenses
        ListView.builder(
          shrinkWrap: true,
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return DailyExpenseCard(
              id: expense.id,
              category: expense.categoryName,
              name: expense.name,
              amount: expense.amount,
              onTap: () {
                setState(() {
                  selectedExpenseId = null;
                });
              },
              onLongPress: () {
                setState(() {
                  selectedExpenseId = expense.id;
                });
              },
              selectedExpenseId: selectedExpenseId,
            );
          },
        ),
      ],
    );
  }

  // Widget For MOnthly Expenses
  Widget widgetMontlyExpenses(List<Expense> allExpenses) {
    // Get Month, and Year
    String month = DateFormat('MMMM').format(selectedDate);
    String year = selectedDate.year.toString();

    // // Previous Month Expenses
    // List<Expense> previousMonthExpenses = allExpenses.where((expense) {
    //   if (selectedDate.month == 1) {
    //     return expense.datetime.year == selectedDate.year - 1 &&
    //         expense.datetime.month == 12;
    //   } else {
    //     return expense.datetime.year == selectedDate.year &&
    //         expense.datetime.month == selectedDate.month;
    //   }
    // }).toList();

    // final previousTotalMonthIncome = previousMonthExpenses
    //     .where((expense) => expense.type == ExpenseType.Income)
    //     .toList()
    //     .fold(0.0, (sum, expense) => sum + expense.amount);
    // final previousTotalMonthExpense = previousMonthExpenses
    //     .where((expense) => expense.type == ExpenseType.Expense)
    //     .toList()
    //     .fold(0.0, (sum, expense) => sum + expense.amount);

    // final carryForward = previousTotalMonthIncome - previousTotalMonthExpense;

    // Current Month Expenses
    List<Expense> currentMonthExpenses = allExpenses
        .where((expense) =>
            expense.datetime.year == selectedDate.year &&
            expense.datetime.month == selectedDate.month)
        .toList();

    final totalMonthIncome = currentMonthExpenses
        .where((expense) => expense.type == ExpenseType.Income)
        .toList()
        .fold(0.0, (sum, expense) => sum + expense.amount);
    final totalMonthExpense = currentMonthExpenses
        .where((expense) => expense.type == ExpenseType.Expense)
        .toList()
        .fold(0.0, (sum, expense) => sum + expense.amount);

    // Group expenses by day
    Map<String, List<Expense>> groupedExpenses = {};

    for (var expense in currentMonthExpenses) {
      String dayKey = DateFormat('yyyy-MM-dd').format(expense.datetime);

      if (!groupedExpenses.containsKey(dayKey)) {
        groupedExpenses[dayKey] = [];
      }

      groupedExpenses[dayKey]!.add(expense);
    }

    // Sort keys (dates) in descending order
    List<String> sortedDates = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        // Date Field
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous Date Icon
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = DateTime(
                      selectedDate.year,
                      selectedDate.month - 1,
                      selectedDate.day,
                    );
                  });
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 36,
                ),
              ),

              // Date
              GestureDetector(
                onTap: () => showMonthSelector(),
                child: Row(
                  children: [
                    // Month
                    Text(
                      month,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Year
                    Text(
                      year,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // Next Date Icon
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = DateTime(
                      selectedDate.year,
                      selectedDate.month + 1,
                      selectedDate.day,
                    );
                  });
                },
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 36,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Income, Expense, Balance Information
        Container(
          height: 110,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Income & Expense
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income (Credit)',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      Text(
                        '₹ $totalMonthIncome',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Expense (Debit)',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      Text(
                        '₹ $totalMonthExpense',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      )
                    ],
                  ),
                ],
              ),

              // C/F and Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'C / F',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      Text(
                        '₹ 00.00',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      Text(
                        '₹ ${totalMonthIncome - totalMonthExpense}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // All Month Expenses
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              // Get the date and expenses for date
              String dateKey = sortedDates[index];
              List<Expense> dailyExpenses = groupedExpenses[dateKey]!;

              return Container(
                margin: (index == sortedDates.length - 1)
                    ? EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 8.0, bottom: 77.0)
                    : EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date Header
                    Text(
                      DateFormat('dd MMM yyyy').format(DateTime.parse(dateKey)),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Expense List for the Day
                    Column(
                      children: dailyExpenses.map((expense) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                expense.name,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                "₹ ${expense.amount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: expense.type == ExpenseType.Income
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget For Yearly Expenses
  Widget widgetYearlyExpenses(List<Expense> allExpenses) {
    // Get Year
    String year = selectedDate.year.toString();

    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    List<Expense> filteredExpenses = allExpenses
        .where((expense) => expense.datetime.year == selectedDate.year)
        .toList();

    // Group expenses by day
    Map<String, List<Expense>> groupedExpenses = {};

    for (var expense in filteredExpenses) {
      String monthKey = DateFormat('MMM').format(expense.datetime);

      if (!groupedExpenses.containsKey(monthKey)) {
        groupedExpenses[monthKey] = [];
      }

      groupedExpenses[monthKey]!.add(expense);
    }

    return Column(
      children: [
        // Date Field
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous Date Icon
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = DateTime(
                      selectedDate.year - 1,
                      selectedDate.month,
                      selectedDate.day,
                    );
                  });
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 36,
                ),
              ),

              // Date
              GestureDetector(
                onTap: () => showYearSelector(),
                child: Row(
                  children: [
                    // Year
                    Text(
                      year,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // Next Date Icon
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = DateTime(
                      selectedDate.year + 1,
                      selectedDate.month,
                      selectedDate.day,
                    );
                  });
                },
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 36,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Income - Expense Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 28),
            Row(
              children: [
                Text('Income (Credit)'),
                const SizedBox(width: 16),
                Text('Expense (Debit)'),
              ],
            ),
            Text('Balance'),
          ],
        ),

        // C/F & Balance
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('C / F'),
              Text('₹ 0.00'),
            ],
          ),
        ),

        // List<Expenses>
        ListView.builder(
          shrinkWrap: true,
          itemCount: 12,
          itemBuilder: (context, index) {
            final monthIncomes = groupedExpenses[months[index]]
                    ?.where((expense) => expense.type == ExpenseType.Income)
                    .toList() ??
                [];
            final monthExpenses = groupedExpenses[months[index]]
                    ?.where((expense) => expense.type == ExpenseType.Expense)
                    .toList() ??
                [];

            final totalMonthIncome =
                monthIncomes.fold(0.0, (sum, expense) => sum + expense.amount);
            final totalMonthExpense =
                monthExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

            // if (monthIncomes.isEmpty && monthExpenses.isEmpty) {
            //   return const SizedBox();
            // }

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Month Name
                      Expanded(
                        flex: 1,
                        child: Text(
                          months[index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Total Month Income
                      Expanded(
                        flex: 2,
                        child: Text(
                          '₹ ${totalMonthIncome.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          // style: TextStyle(color: Colors.green),
                        ),
                      ),

                      // Total Month Expense
                      Expanded(
                        flex: 2,
                        child: Text(
                          '₹ ${totalMonthExpense.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          // style: TextStyle(color: Colors.red),
                        ),
                      ),

                      // Month Balance
                      Expanded(
                        flex: 2,
                        child: Text(
                          '₹ ${(totalMonthIncome - totalMonthExpense).toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              // color: (totalMonthIncome - totalMonthExpense) >= 0
                              //     ? Colors.green
                              //     : Colors.red,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 2),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
