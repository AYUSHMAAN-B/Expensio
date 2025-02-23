import 'package:expense_tracker/models/pot.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PotCard extends StatelessWidget {
  final Pot pot;

  const PotCard({super.key, required this.pot});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: pot.iconPath == null ? Icon(
              Icons.savings,
              size: 58,
            ) : Image.asset(pot.iconPath!),
          ),

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

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Name
              Text(
                pot.sofar.toString(),
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
                pot.goal.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
