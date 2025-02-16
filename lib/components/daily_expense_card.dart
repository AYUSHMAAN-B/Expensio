import 'package:flutter/material.dart';

class DailyExpenseCard extends StatelessWidget {
  final String id;
  final String? category;
  final String name;
  final double amount;

  final Function() onTap;
  final Function() onLongPress;
  final String? selectedExpenseId;

  const DailyExpenseCard({
    super.key,
    required this.id,
    required this.category,
    required this.name,
    required this.amount,
    required this.onTap,
    required this.onLongPress,
    required this.selectedExpenseId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        color: (selectedExpenseId == id) ? Colors.blueGrey : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Category and Name
            Row(
              children: [
                if (category != null) ...[
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    child: Center(
                      child: Text(
                        category![0],
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              '₹ $amount',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
