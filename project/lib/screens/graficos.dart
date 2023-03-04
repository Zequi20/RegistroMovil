import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/transacciones_chart_anual.dart';
import '../widgets/transacciones_chart_mensual.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              icon: const Icon(Icons.exit_to_app))
        ],
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              strokeAlign: BorderSide.strokeAlignOutside,
              width: 1,
              color: Colors.white),
        ),
        title: const Center(
            child: Text(
          style: TextStyle(
            shadows: [
              Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 4),
            ],
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          'Analisis general',
          textAlign: TextAlign.center,
        )),
        backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1, 2),
                              blurRadius: 4),
                        ],
                        border: Border.all(color: Colors.white, width: 3),
                        color: bfColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: const BarChartTransacciones())),
            AspectRatio(
                aspectRatio: 1,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1, 2),
                              blurRadius: 4),
                        ],
                        border: Border.all(color: Colors.white, width: 3),
                        color: bfColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: const BarChartTransaccionesMensuales()))
          ],
        ),
      ),
    ));
  }
}
