import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class DonutChart extends StatefulWidget {
  const DonutChart({super.key});

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  @override
  Widget build(BuildContext context) {
    var bfColor = Colors.blue.shade600.withOpacity(0.7);
    var bfColorBtn = Colors.indigo.shade900.withOpacity(0.7);
    var charTextStyle = const TextStyle(
      shadows: [
        Shadow(color: Colors.black, offset: Offset(1, 2), blurRadius: 8)
      ],
      color: Colors.white,
      fontSize: 16,
    );

    var statTextStyle = const TextStyle(
      shadows: [
        Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 4),
      ],
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    return FutureBuilder(
      future: getChartData('http://192.168.0.7:8474/general'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        NumberFormat f = NumberFormat("#,##0.00", "es_AR");
        if (snapshot.hasData) {
          return Column(
            children: [
              Expanded(
                child: PieChart(PieChartData(
                    startDegreeOffset: 30,
                    centerSpaceRadius: 0,
                    sections: [
                      PieChartSectionData(
                          radius: 95,
                          value: snapshot.data[0],
                          color: bfColorBtn,
                          showTitle: true,
                          title: 'Gastos',
                          titleStyle: charTextStyle),
                      PieChartSectionData(
                          radius: 95,
                          value: snapshot.data[1],
                          color: bfColor,
                          showTitle: true,
                          title: 'Ingresos',
                          titleStyle: charTextStyle)
                    ])),
              ),
              Container(
                decoration: BoxDecoration(
                    color: bfColorBtn,
                    border: const Border(top: BorderSide(color: Colors.white)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, -6),
                          blurRadius: 10)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: bfColor,
                                      border: Border.all(color: Colors.white)),
                                  width: 20,
                                  height: 20,
                                ),
                                Text(
                                  ' ${f.format(snapshot.data[1])} Gs',
                                  style: statTextStyle,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: bfColorBtn,
                                      border: Border.all(color: Colors.white)),
                                  width: 20,
                                  height: 20,
                                ),
                                Text(
                                  ' ${f.format(snapshot.data[0])} Gs',
                                  style: statTextStyle,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
                        color: bfColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed('GraphSelect');
                        },
                        child: Center(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.pie_chart,
                                color: Colors.white,
                              ),
                              Text(
                                ' Graficos',
                                style: charTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue.shade600.withOpacity(0.7),
              backgroundColor: Colors.white,
              strokeWidth: 8,
            ),
          );
        }
      },
    );
  }

  Future getChartData(String dataUrl) async {
    var request = http.Request('GET', Uri.parse(dataUrl));

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List lista = jsonDecode(response.body);

    List<double> valores = lista
        .map((e) => double.parse(e['sum(valor_transaccion)'].toString()))
        .toList();

    return valores;
  }
}
