import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import '../models/model_transaccion_mensual.dart';

class BarChartTransaccionesMensualesSede extends StatefulWidget {
  const BarChartTransaccionesMensualesSede(
      {super.key,
      required this.anual,
      required this.mensual,
      required this.sede});
  final String anual;
  final String mensual;
  final String sede;
  @override
  State<BarChartTransaccionesMensualesSede> createState() =>
      _BarChartTransaccionesMensualesSedeState();
}

class _BarChartTransaccionesMensualesSedeState
    extends State<BarChartTransaccionesMensualesSede> {
  List<TransaccionMensual> transacciones = [];
  List<String> anios = [];
  List<String> meses = [];

  double mayor = 0;
  List<String> mesanio = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre'
  ];
  @override
  Widget build(BuildContext context) {
    var bfColor = Colors.blue.shade600.withOpacity(0.7);

    var bfColorBtn = Colors.indigo.shade900.withOpacity(0.7);

    var barsBorder = BorderSide(color: bfColor, width: 2);

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
      future: getChartData(
          'http://132.255.166.73:8474/ingresos/mensuales_por_sede'),
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
                          interval: mayor / 4,
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) => Text(
                            meta.formattedValue,
                            style: charTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        )),
                        topTitles: AxisTitles(
                            drawBehindEverything: true,
                            axisNameSize: 50,
                            axisNameWidget: Text(
                              'Ingresos ${mesanio[int.parse(widget.mensual) - 1]} del ${widget.anual}',
                              style: charTextStyle,
                            ),
                            sideTitles: SideTitles(showTitles: false)),
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 30,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${value.toInt() - 1}',
                                  style: mesTextStyle,
                                ),
                              );
                            },
                          ),
                        )),
                    maxY: mayor,
                    barGroups: List.generate(transacciones.length, (index) {
                      return BarChartGroupData(barRods: [
                        BarChartRodData(
                          gradient:
                              LinearGradient(colors: [Colors.white, bfColor]),
                          toY: transacciones[index].valor,
                          width: 6,
                          borderSide: barsBorder,
                        )
                      ], x: transacciones[index].dia);
                    }))),
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
    transacciones.clear();
    anios.clear();
    meses.clear();

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('GET', Uri.parse(dataUrl));
    request.bodyFields = {
      'anio': widget.anual,
      'mes': widget.mensual,
      'sede': widget.sede
    };

    request.headers.addAll(headers);

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List lista = jsonDecode(response.body);

    for (var element in lista) {
      transacciones.add(TransaccionMensual(
          double.parse(element['valor'].toString()), element['dia']));
    }

    var request2 = http.Request(
        'GET', Uri.parse('http://132.255.166.73:8474/anios_por_sede'));
    request2.bodyFields = {'sede': widget.sede};

    http.StreamedResponse responseStream2 = await request2.send();
    var response2 = await http.Response.fromStream(responseStream2);

    List lista2 = jsonDecode(response2.body);

    for (var element in lista2) {
      anios.add(element['anios'].toString());
    }

    var request3 = http.Request(
        'GET', Uri.parse('http://132.255.166.73:8474/meses_por_sede'));
    request3.bodyFields = {'anio': widget.anual, 'sede': widget.sede};
    http.StreamedResponse responseStream3 = await request3.send();
    var response3 = await http.Response.fromStream(responseStream3);

    List lista3 = jsonDecode(response3.body);

    for (var element in lista3) {
      meses.add(element['meses'].toString());
    }

    mayor = getMayor(transacciones);
    return transacciones;
  }

  void getMeses() async {}

  double getMayor(List<TransaccionMensual> m) {
    double res = 0;

    for (var element in m) {
      if (element.valor > res) {
        res = element.valor;
      }
    }

    return res;
  }
}
