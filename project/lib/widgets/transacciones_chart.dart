import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import '../models/transaccion_anual.dart';

class BarChartTransacciones extends StatefulWidget {
  const BarChartTransacciones({super.key});

  @override
  State<BarChartTransacciones> createState() => _BarChartTransaccionesState();
}

class _BarChartTransaccionesState extends State<BarChartTransacciones> {
  List<TransaccionAnual> transacciones = [];

  @override
  Widget build(BuildContext context) {
    var bfColor = Colors.blue.shade600.withOpacity(0.7);

    var bfColorBtn = Colors.indigo.shade900.withOpacity(0.7);

    var barsBorder = const BorderSide(color: Colors.white, width: 2);

    List<String> meses = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];

    var basicShadow =
        const Shadow(color: Colors.black, offset: Offset(1, 2), blurRadius: 8);
    var titleShadow =
        const Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 4);

    var charTextStyle = TextStyle(
      shadows: [basicShadow],
      color: Colors.white,
      fontSize: 16,
    );
    var mesTextStyle = TextStyle(
      shadows: [basicShadow],
      color: Colors.white,
      fontSize: 13,
    );
    // ignore: unused_local_variable
    var statTextStyle = TextStyle(
      shadows: [
        titleShadow,
      ],
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return FutureBuilder(
      future: getChartData('http://192.168.0.7:8474/anales'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Expanded(
                child: BarChart(BarChartData(
                    borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.white, width: 2)),
                    gridData: FlGridData(show: false),
                    backgroundColor: bfColorBtn,
                    titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            return Center(
                              child: Text(
                                meta.formattedValue,
                                style: charTextStyle,
                              ),
                            );
                          },
                        )),
                        topTitles: AxisTitles(
                            axisNameSize: 50,
                            axisNameWidget: Text(
                              'Ingresos 2023',
                              style: charTextStyle,
                            ),
                            sideTitles: SideTitles(showTitles: false)),
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 50,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  meses[value.toInt()],
                                  style: mesTextStyle,
                                ),
                              );
                            },
                          ),
                        )),
                    maxY: getMayor(transacciones),
                    barGroups: List.generate(transacciones.length, (index) {
                      return BarChartGroupData(barRods: [
                        BarChartRodData(
                            color: bfColor,
                            toY: transacciones[index].valor,
                            width: 6,
                            borderSide: barsBorder)
                      ], x: index);
                    }))),
              )
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
    //print(lista[0]['valor']);
    for (var element in lista) {
      transacciones.add(TransaccionAnual(
          double.parse(element['valor'].toString()), element['mes']));
    }
    //print(transacciones);
    return transacciones;
  }

  double getMayor(List<TransaccionAnual> m) {
    double res = 0;

    for (var element in m) {
      if (element.valor > res) {
        res = element.valor;
      }
    }
    return res;
  }
}
