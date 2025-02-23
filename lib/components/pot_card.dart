import 'package:expense_tracker/models/pot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PotCard extends StatelessWidget {
  final Pot pot;
  final void Function() onTapped;
  final void Function() onEditPressed;
  final void Function() onDeletePressed;

  const PotCard({
    super.key,
    required this.pot,
    required this.onTapped,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

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
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEditPressed(),
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          SlidableAction(
            onPressed: (context) => onDeletePressed(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => onTapped(),
        child: Container(
          height: 75,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withAlpha(100),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: pot.iconPath == null
                    ? Icon(
                        Icons.savings,
                        size: 58,
                      )
                    : Image.asset(pot.iconPath!),
              ),
        
              // Name & Indicator
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        pot.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
        
                    // Progress Bar
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * 0.58,
                      lineHeight: 8.0,
                      percent: (pot.sofar / pot.goal),
                      barRadius: Radius.circular(12),
                      progressColor: Theme.of(context).colorScheme.tertiary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
        
              // SoFar & Goal
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name
                  Text(
                    formatIndianCurrency(pot.sofar.toInt()),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
        
                  SizedBox(
                    width: 60,
                    child: Divider(
                      thickness: 2,
                      color: const Color.fromARGB(255, 7, 106, 84),
                    ),
                  ),
        
                  // Progress Bar
                  Text(
                    formatIndianCurrency(pot.goal.toInt()),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
