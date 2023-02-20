import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  var bfColor = Colors.blue.shade600.withOpacity(0.7);
  var bfColorBtn = Colors.indigo.shade900.withOpacity(0.7);
  var bfTextStyle = const TextStyle(
    shadows: [
      Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 12)
    ],
    color: Colors.white,
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(PieChartData(centerSpaceRadius: 50, sections: [
            PieChartSectionData(
                value: 1200,
                color: bfColor,
                showTitle: true,
                title: 'Gastos',
                titleStyle: bfTextStyle),
            PieChartSectionData(
                value: 1700,
                color: bfColorBtn,
                showTitle: true,
                title: 'Ingresos',
                titleStyle: bfTextStyle)
          ])),
        ),
      ),
    );
  }
}
