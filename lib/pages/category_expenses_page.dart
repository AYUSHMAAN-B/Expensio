import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CategoryExpensesPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryExpensesPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryExpensesPage> createState() => _CategoryExpensesPageState();
}

class _CategoryExpensesPageState extends State<CategoryExpensesPage> {
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

  // Get Month Helper Function
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
    // All Expenses
    List<Expense> allExpenses = [];

    // Get All Expenses In The Date Range
    if (fromDate != null && tillDate != null) {
      final allIncomes =
          listeningProvider.getIncomesForRange(fromDate!, tillDate!);
      final allExpense =
          listeningProvider.getExpensesForRange(fromDate!, tillDate!);

      allExpenses = (allIncomes + allExpense)
          .where((expense) => expense.categoryId == widget.categoryId)
          .toList();
    }

    // Group expenses by day
    Map<String, List<Expense>> groupedExpenses = {};

    for (var expense in allExpenses) {
      String dayKey = DateFormat('yyyy-MM-dd').format(expense.datetime);

      if (!groupedExpenses.containsKey(dayKey)) {
        groupedExpenses[dayKey] = [];
      }

      groupedExpenses[dayKey]!.add(expense);
    }

    // Sort keys (dates) in descending order
    List<String> sortedDates = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Text(widget.categoryName),
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

              // All Expenses
              ListView.builder(
                shrinkWrap: true,
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  // Get the date and expenses for date
                  String dateKey = sortedDates[index];
                  List<Expense> dailyExpenses = groupedExpenses[dateKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // **Date Header with Divider**
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateKey,
                              style: TextStyle(fontSize: 18),
                            ),
                            Divider(thickness: 1.2),
                          ],
                        ),
                      ),

                      // Expenses List
                      Column(
                        children: dailyExpenses.map((expense) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 28.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Expense Name
                                    Text(
                                      expense.name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    // Amount
                                    Text(
                                      "₹ ${expense.amount.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Divider Between Expenses
                              Divider(
                                indent: 20,
                                endIndent: 8,
                                thickness: 0.5,
                              ),
                            ],
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
