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
  DateTime? fromDate;
  DateTime? tillDate;

  // Selected Type
  String selectedType = 'Monthly';

  // Selected Expense Type
  var selectedExpenseType = ExpenseType.Expense;

  // Providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // Range Date Dialog
  Future<void> showDateSelector({String? which}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    setState(() {
      (which == 'From') ? fromDate = pickedDate : tillDate = pickedDate;
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

  String getMonth(int month, String text) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    // Get Month and Year
    String monthName = DateFormat('MMM').format(selectedDate);
    int month = selectedDate.month;
    int year = selectedDate.year;

    double totalIncome;
    double totalExpense;

    // Get Total [ Income / Expense ] For SelectedDate
    if (fromDate == null || tillDate == null) {
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
    }

    // Get Total [ Income / Expense ] For [ FromDate -> TillDate ]
    else {
      final allIncomes =
          listeningProvider.getIncomesForRange(fromDate!, tillDate!);
      final allExpenses =
          listeningProvider.getExpensesForRange(fromDate!, tillDate!);

      totalIncome =
          allIncomes.fold(0.0, (sum, expense) => sum + expense.amount);
      totalExpense =
          allExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    }

    // Get Expense Category Map
    final expenseCategoryMap = listeningProvider.expenseCategoryMap;

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
                    fromDate = DateTime(year, 1, 1);
                    tillDate = DateTime(year, 12, 31);
                  } else {
                    selectedType = 'Monthly';
                    fromDate = DateTime(year, month, 1);
                    tillDate = DateTime(
                        year, month, DateTime.now().lastDayOfMonth()!.day);
                  }
                });
              },
              child: Text(selectedType),
            ),
            ...((selectedType == 'Monthly')
                ? [
                    // Prev Date Icon
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
                    // Prev Date Icon
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
              // Custom Date Range
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 22.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // From Date Box
                    Expanded(
                      child: GestureDetector(
                        onTap: () => showDateSelector(which: 'From'),
                        child: Container(
                          height: 65,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(' From'),
                              Center(
                                  child: Text(
                                (fromDate != null)
                                    ? '${getMonth(fromDate!.month, 'From Date')} ${fromDate!.day}, ${fromDate!.year}'
                                    : 'Select',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // To Date Box
                    Expanded(
                      child: GestureDetector(
                        onTap: () => showDateSelector(which: 'Till'),
                        child: Container(
                          height: 65,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(' Till'),
                              Center(
                                  child: Text(
                                (tillDate != null)
                                    ? '${getMonth(tillDate!.month, 'Till Date')} ${tillDate!.day}, ${tillDate!.year}'
                                    : 'Select',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
              SizedBox(
                height: 300,
                width: 300,
                child: Stack(
                  children: [
                    ExpensePieChart(
                      expenseCategoryMap: expenseCategoryMap,
                      totalIncome: totalIncome,
                      totalExpense: totalExpense,
                      selectedType: selectedType,
                      selectedExpenseType: selectedExpenseType,
                      selectedDate: selectedDate,
                      fromDate: fromDate,
                      tillDate: tillDate,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                  ],
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     // Total Income / Expense
              //     Column(
              //       children: [
              //         Text(
              //           (selectedExpenseType == ExpenseType.Expense)
              //               ? 'Total Expense'
              //               : 'Total Income',
              //           style: TextStyle(fontSize: 22),
              //         ),
              //         Text(
              //           (selectedExpenseType == ExpenseType.Income)
              //               ? formatIndianCurrency(totalIncome.toInt())
              //               : formatIndianCurrency(totalExpense.toInt()),
              //           style: TextStyle(
              //             fontSize: 22,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ],
              //     ),

              //     SizedBox(
              //       height: 200,
              //       width: 200,
              //       child: Stack(
              //         children: [
              //           ExpensePieChart(
              //             expenseCategoryMap: expenseCategoryMap,
              //             totalIncome: totalIncome,
              //             totalExpense: totalExpense,
              //             selectedType: selectedType,
              //             selectedExpenseType: selectedExpenseType,
              //             selectedDate: selectedDate,
              //           ),
              //           Center(
              //             child: Icon(
              //               Icons.category,
              //               size: 44,
              //               color: Theme.of(context).colorScheme.primary,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

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
                  if (fromDate == null || tillDate == null) {
                    currentExpenses = currentExpenses.where((expense) {
                      bool typeMatches = expense.type == selectedExpenseType;
                      bool dateMatches = (selectedType == 'Monthly')
                          ? (expense.datetime.year == selectedDate.year &&
                              expense.datetime.month == selectedDate.month)
                          : (expense.datetime.year == selectedDate.year);

                      return typeMatches && dateMatches;
                    }).toList();
                  } else {
                    currentExpenses = currentExpenses.where((expense) {
                      bool typeMatches = expense.type == selectedExpenseType;
                      bool dateMatches = expense.datetime
                              .isAfter(fromDate!.subtract(Duration(days: 1))) &&
                          expense.datetime
                              .isBefore(tillDate!.add(Duration(days: 1)));

                      return typeMatches && dateMatches;
                    }).toList();
                  }

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
                                width: 50,
                                decoration: BoxDecoration(
                                  color: categoryColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                categoryName,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
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

                        // // Category Name
                        // Expanded(
                        //   flex: 2,
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         height: 22,
                        //         width: 22,
                        //         decoration: BoxDecoration(
                        //           color: categoryColor,
                        //           shape: BoxShape.rectangle,
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(2)),
                        //         ),
                        //         child: Center(
                        //           child: Text(
                        //             categoryName[0],
                        //             style: TextStyle(
                        //               fontSize: 16,
                        //               color: Theme.of(context)
                        //                   .colorScheme
                        //                   .tertiary,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       const SizedBox(width: 5),
                        //       Text(
                        //         categoryName,
                        //         style: TextStyle(fontSize: 16),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // // Category Color
                        // Expanded(
                        //   flex: 1,
                        //   child: Container(
                        //     height: 25,
                        //     width: 25,
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: categoryColor,
                        //     ),
                        //   ),
                        // ),

                        // // Category Amount
                        // Expanded(
                        //   flex: 1,
                        //   child: Text(
                        //     '₹ ${categoryTotal.toStringAsFixed(2)}',
                        //     style: TextStyle(fontSize: 16),
                        //     textAlign: TextAlign.right,
                        //   ),
                        // ),
                      ],
                    ),
                  );
                },
              ),

              // Line Chart
              // LineChartCard(),
            ],
          ),
        ),
      ),
    );
  }
}
