// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:expense_tracker/components/daily_expense_card.dart';
import 'package:expense_tracker/components/my_drawer.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Tab Controller
  late final tabController;

  // Date
  DateTime selectedDate = DateTime.now();

  // Controllers
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  // Add Expense Dialog
  void addExpense() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        // Selected Expense Type
        ExpenseType type = ExpenseType.Expense;

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
                                  type = ExpenseType.Income;
                                });
                              },
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: (type == ExpenseType.Income)
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
                                  child: Text('Income'),
                                ),
                              ),
                            ),
                          ),

                          // Expense Box
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  type = ExpenseType.Expense;
                                });
                              },
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: (type == ExpenseType.Expense)
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
                                  child: Text('Expense'),
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
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  border: InputBorder.none,
                                ),
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
                              Navigator.of(context).pop();
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
    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),

      // Drawer
      drawer: MyDrawer(),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => addExpense(),
        child: Icon(Icons.add),
      ),

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
                  widgetDailyExpenses(),

                  // Monthly Expenses
                  widgetMontlyExpenses(),

                  // Yearly Expenses
                  widgetYearlyExpenses(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetDailyExpenses() {
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
                ),
              ),
              Text(
                '₹ 0.00',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Tap on \'+\' to add new item and long press an entry to edit.',
          style: TextStyle(
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 16),

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
                ),
              ),
              Text(
                '₹ 400.00',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              // Expenses

              DailyExpenseCard(
                name: 'Snacks',
                amount: 80.00,
              ),
              DailyExpenseCard(
                category: 'Wants',
                name: 'Order',
                amount: 240.00,
              ),
              DailyExpenseCard(
                category: 'Needs',
                name: 'Needs',
                amount: 180.00,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget widgetMontlyExpenses() {
    // Get Month, and Year
    String month = DateFormat('MMMM').format(selectedDate);
    String year = selectedDate.year.toString();

    return Column(
      children: [
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
        )
      ],
    );
  }

  Widget widgetYearlyExpenses() {
    // Get Year
    String year = selectedDate.year.toString();

    return Column(
      children: [
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
        )
      ],
    );
  }
}
