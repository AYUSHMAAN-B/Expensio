import 'package:expense_tracker/components/pie_chart.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  // Selected Date
  DateTime selectedDate = DateTime.now();

  // Selected Type
  String selectedType = 'Monthly';

  // Selected Expense Type
  var selectedExpenseType = ExpenseType.Expense;

  // Providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

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

  // Format Amount
  String formatIndianCurrency(int amount) {
    if (amount >= 10000000) {
      return "₹ ${(amount / 10000000).toStringAsFixed(2)} Cr";
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
    // Get Month and Year
    String monthName = DateFormat('MMMM').format(selectedDate);
    int month = selectedDate.month;
    int year = selectedDate.year;

    double totalIncome;
    double totalExpense;

    // Get Total Income / Expense For SelectedDate
    if (selectedType == 'Monthly') {
      final allIncomes =
          listeningProvider.getIncomesForMonth(month, year, selectedDate);
      final allExpenses =
          listeningProvider.getExpensesForMonth(month, year, selectedDate);

      totalIncome =
          allIncomes.fold(0.0, (sum, expense) => sum + expense.amount);
      totalExpense =
          allExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    } else {
      final allIncomes =
          listeningProvider.getIncomesForYear(year, selectedDate);
      final allExpenses =
          listeningProvider.getExpensesForYear(year, selectedDate);

      totalIncome =
          allIncomes.fold(0.0, (sum, expense) => sum + expense.amount);
      totalExpense =
          allExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    }

    // Get Expense Category Map
    final expenseCategoryMap = databaseProvider.expenseCategoryMap;

    return Scaffold(
      // Background color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedType == 'Monthly') {
                    selectedType = 'Yearly';
                  } else {
                    selectedType = 'Monthly';
                  }
                });
              },
              child: Text(selectedType),
            ),
            ...((selectedType == 'Monthly')
                ? [
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
                          Text(
                            monthName,
                            style: TextStyle(fontSize: 22),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            year.toString(),
                            style: TextStyle(fontSize: 22),
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
                  ]
                : [
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
                            year.toString(),
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
                  ]),
          ],
        ),
        centerTitle: true,
      ),

      // Body
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Income [OR] Expense Toggle
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 64.0,
                  vertical: 22.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Income Box
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            // Updates only modal state
                            selectedExpenseType = ExpenseType.Income;
                          });
                        },
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: (selectedExpenseType == ExpenseType.Income)
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.surface,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary),
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
                          setState(() {
                            selectedExpenseType = ExpenseType.Expense;
                          });
                        },
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: (selectedExpenseType == ExpenseType.Expense)
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.surface,
                            border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                              bottom: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                              right: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
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

              // Total & Pie Chart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Total Income / Expense
                  Column(
                    children: [
                      Text(
                        (selectedExpenseType == ExpenseType.Expense)
                            ? 'Total Expense'
                            : 'Total Income',
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                        (selectedExpenseType == ExpenseType.Income)
                            ? formatIndianCurrency(totalIncome.toInt())
                            : formatIndianCurrency(totalExpense.toInt()),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack(
                      children: [
                        ExpensePieChart(
                          expenseCategoryMap: expenseCategoryMap,
                          totalIncome: totalIncome,
                          totalExpense: totalExpense,
                          selectedType: selectedType,
                          selectedExpenseType: selectedExpenseType,
                          selectedDate: selectedDate,
                        ),
                        Center(
                          child: Icon(
                            Icons.category,
                            size: 44,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    'All Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Category Wise Spendings
              ListView.builder(
                shrinkWrap: true,
                itemCount: expenseCategoryMap.length,
                itemBuilder: (context, index) {
                  // Get the category name
                  String categoryId = expenseCategoryMap.keys.elementAt(index);

                  // Get expenses for the current category
                  List<Expense> currentExpenses =
                      expenseCategoryMap[categoryId] ?? [];

                  // Filter expenses based on selected type and time period
                  currentExpenses = currentExpenses.where((expense) {
                    bool typeMatches = expense.type == selectedExpenseType;
                    bool dateMatches = (selectedType == 'Monthly')
                        ? (expense.datetime.year == selectedDate.year &&
                            expense.datetime.month == selectedDate.month)
                        : (expense.datetime.year == selectedDate.year);

                    return typeMatches && dateMatches;
                  }).toList();

                  // Calculate total sum for the category
                  double categoryTotal = currentExpenses.fold(
                      0.0, (sum, expense) => sum + expense.amount);

                  // String Category Name
                  String categoryName = (currentExpenses.isEmpty)
                      ? 'NA'
                      : currentExpenses[0].categoryName ?? 'NA';

                  // String Category Color
                  Color categoryColor = (currentExpenses.isEmpty)
                      ? Colors.transparent
                      : currentExpenses[0].categoryColor ?? Colors.transparent;

                  if (categoryName == 'NA') {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category Name
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Container(
                                height: 22,
                                width: 22,
                                decoration: BoxDecoration(
                                  color: categoryColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                ),
                                child: Center(
                                  child: Text(
                                    categoryName[0],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                categoryName,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        // Category Color
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: categoryColor,
                            ),
                          ),
                        ),

                        // Category Amount
                        Expanded(
                          flex: 1,
                          child: Text(
                            '₹ ${categoryTotal.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
