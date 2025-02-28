import 'dart:io';
import 'package:expense_tracker/models/expense.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static Future<void> generateExpensePdf(
    List<Expense> expenses,
    DateTime fromDate,
    DateTime tillDate,
  ) async {
    final pdf = pw.Document();

    // Format dates properly for title
    String formattedFromDate = DateFormat('dd MMM yyyy').format(fromDate);
    String formattedTillDate = DateFormat('dd MMM yyyy').format(tillDate);

    // Group expenses by date
    Map<String, List<Expense>> groupedExpenses = {};
    for (var expense in expenses) {
      String dayKey = DateFormat('yyyy-MM-dd').format(expense.datetime);
      groupedExpenses.putIfAbsent(dayKey, () => []).add(expense);
    }

    // Sort dates in ascending order
    List<String> sortedDates = groupedExpenses.keys.toList()..sort();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            // Title
            pw.Text(
              "\t\tExpense Report\n($formattedFromDate - $formattedTillDate)",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 20),

            // If no expenses are found, show message
            if (expenses.isEmpty)
              pw.Text("No expenses recorded for the selected date range.",
                  style: pw.TextStyle(fontSize: 14)),

            // Iterate through each date and list expenses
            ...sortedDates.map((date) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Date Header
                  pw.Container(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Text(
                      DateFormat('dd MMM yyyy').format(DateTime.parse(date)),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),

                  // Expenses Table for this Date
                  pw.TableHelper.fromTextArray(
                    headers: ["Category", "Expense", "Amount"],
                    data: groupedExpenses[date]!.map((expense) {
                      return [
                        expense.categoryName,
                        expense.name,
                        expense.type == ExpenseType.Expense
                            ? " - Rs. ${expense.amount.toStringAsFixed(2)}"
                            : " + Rs. ${expense.amount.toStringAsFixed(2)}"
                      ];
                    }).toList(),
                    headerStyle: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    cellAlignment: pw.Alignment.centerLeft,
                    columnWidths: {
                      0: pw.FlexColumnWidth(1),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                    },
                  ),

                  pw.SizedBox(height: 10),
                ],
              );
            }),
          ];
        },
      ),
    );

    // Save in Downloads folder
    final downloadsDir = Directory("/storage/emulated/0/Download");
    final filePath = "${downloadsDir.path}/expenses_report.pdf";

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    await OpenFilex.open(filePath);

    print("PDF saved to $filePath");
  }
}
