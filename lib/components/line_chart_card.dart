import 'package:expense_tracker/fake_line_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartCard extends StatelessWidget {
  const LineChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final data = LineData();

    return Container(
      padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: LineChart(
              LineChartData(
                // Line Touch Data
                lineTouchData: const LineTouchData(handleBuiltInTouches: true),

                // Grid Data
                gridData: const FlGridData(show: false),

                // Tiles Data
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data.bottomTitle[value.toInt()] != null
                            ? SideTitleWidget(
                                meta: meta,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Text(
                                    data.bottomTitle[value.toInt()].toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data.leftTitle[value.toInt()] != null
                            ? SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  data.leftTitle[value.toInt()].toString(),
                                  style: TextStyle(fontSize: 12),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                ),

                // Border Data
                borderData: FlBorderData(show: false),

                // Actual Line Data
                lineBarsData: [
                  LineChartBarData(
                    color: Colors.green,
                    barWidth: 2.5,
                    belowBarData: BarAreaData(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.green, Colors.transparent]),
                        show: true),
                    dotData: const FlDotData(show: false),
                    spots: data.spots,
                  )
                ],

                // Something else
                minX: 0,
                maxX: 32,
                minY: 0,
                maxY: 700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
