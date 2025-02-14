// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:expense_tracker/components/my_drawer.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  // Add Expense Dialog
  void addExpense() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                // Income [OR] Expense
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Text('Income'),
                      Text('Expense'),
                    ],
                  ),
                ),

                // Category, Name & Amount
                Row(
                  children: [
                    Icon(Icons.category),
                    const SizedBox(width: 15),
                    const SizedBox(
                      height: 25,
                      width: 50,
                      child: TextField(),
                    ),
                    const SizedBox(width: 15),
                    const SizedBox(
                      height: 25,
                      width: 50,
                      child: TextField(),
                    ),
                  ],
                ),

                // Description
                const SizedBox(
                  height: 25,
                  width: 100,
                  child: TextField(),
                ),

                // Save Button
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.done)),
                  ],
                ),

                const SizedBox(height: 50),
              ],
            ),
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
    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Text(AuthService().getCurrentUser()?.displayName ?? 'NULL Name'),
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
        )
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
