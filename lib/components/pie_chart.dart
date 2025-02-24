import 'package:expense_tracker/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, List<Expense>> expenseCategoryMap;
  final double totalIncome;
  final double totalExpense;
  final String selectedType;
  final ExpenseType selectedExpenseType;
  final DateTime selectedDate;

  const ExpensePieChart({
    super.key,
    required this.expenseCategoryMap,
    required this.totalIncome,
    required this.totalExpense,
    required this.selectedType,
    required this.selectedExpenseType,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Generate Pie Chart Data
    List<PieChartSectionData> pieChartSections = [];

    expenseCategoryMap.forEach((categoryId, expenses) {
      // Filter expenses based on selected type and time period
      expenses = expenses.where((expense) {
        bool typeMatches = expense.type == selectedExpenseType;
        bool dateMatches = (selectedType == 'Monthly')
            ? (expense.datetime.year == selectedDate.year &&
                expense.datetime.month == selectedDate.month)
            : (expense.datetime.year == selectedDate.year);

        return typeMatches && dateMatches;
      }).toList();

      // Calculate total sum for the category
      double categoryTotal =
          expenses.fold(0.0, (sum, expense) => sum + expense.amount);

      // String Category Color
      Color categoryColor = (expenses.isEmpty)
          ? Colors.transparent
          : expenses[0].categoryColor ?? Colors.transparent;

      double percentage = (selectedExpenseType == ExpenseType.Expense)
          ? (categoryTotal / totalExpense) * 100
          : (categoryTotal / totalIncome) * 100;

      pieChartSections.add(
        PieChartSectionData(
          color: categoryColor,
          value: categoryTotal,
          title: '${percentage.toStringAsFixed(0)}%',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return PieChart(
      PieChartData(
        sections: pieChartSections,
        sectionsSpace: 2,
        centerSpaceRadius: 55,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
