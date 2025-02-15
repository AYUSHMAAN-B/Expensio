import 'package:flutter/material.dart';

class DailyExpenseCard extends StatelessWidget {
  final String? category;
  final String name;
  final double amount;

  const DailyExpenseCard({
    super.key,
    this.category,
    required this.name,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
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
    );
  }
}
