// forecast_widget.dart

// Forecast Widget with chart + list

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models/forecast_model.dart';
import '../../core/utils.dart';

class ForecastWidget extends StatelessWidget {
  final ForecastModel forecast;

  const ForecastWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    if (forecast.days.isEmpty) {
      return const Text('No forecast data');
    }

    // Prepare chart points

    final List<FlSpot> spots = [];
    for (int i = 0; i < forecast.days.length; i++) {
      spots.add(
        FlSpot(i.toDouble(), forecast.days[i].temperature),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Line Chart

        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 ||
                          index >= forecast.days.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        formatDate(forecast.days[index].date),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Forecast List

        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: forecast.days.length,
            itemBuilder: (context, index) {
              final day = forecast.days[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(formatDate(day.date)),
                  subtitle: Text(day.weather),
                  trailing: Text(
                    '${day.temperature.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
