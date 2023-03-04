import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import '../models/model_transaccion_mensual.dart';

class BarChartTransaccionesMensuales extends StatefulWidget {
  const BarChartTransaccionesMensuales({super.key});

  @override
  State<BarChartTransaccionesMensuales> createState() =>
      _BarChartTransaccionesMensualesState();
}

class _BarChartTransaccionesMensualesState
    extends State<BarChartTransaccionesMensuales> {
  List<TransaccionMensual> transacciones = [];
  List<String> anios = [];
  List<String> meses = [];
  String anual = '2023';
  String mensual = '2';
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

    var barsBorder = const BorderSide(color: Colors.white, width: 2);

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
      future: getChartData('http://192.168.0.7:8474/ingresos/mensuales'),
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
                              'Ingresos ${mesanio[int.parse(mensual) - 1]} del $anual',
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
                            color: bfColor,
                            toY: transacciones[index].valor,
                            width: 6,
                            borderSide: barsBorder)
                      ], x: transacciones[index].dia);
                    }))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Año a mostrar:',
                      style: charTextStyle,
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            fillColor: bfColorBtn,
                            filled: true),
                        dropdownColor: bfColorBtn,
                        value: anual,
                        items: List.generate(
                            anios.length,
                            (index) => DropdownMenuItem(
                                  value: anios[index],
                                  child: Text(
                                    anios[index],
                                    style: charTextStyle,
                                  ),
                                )),
                        onChanged: (value) {
                          setState(() {
                            anual = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Mes a mostrar:',
                      style: charTextStyle,
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            fillColor: bfColorBtn,
                            filled: true),
                        dropdownColor: bfColorBtn,
                        value: mensual,
                        items: List.generate(
                            meses.length,
                            (index) => DropdownMenuItem(
                                  value: meses[index],
                                  child: Text(
                                    mesanio[int.parse(meses[index]) - 1],
                                    style: charTextStyle,
                                  ),
                                )),
                        onChanged: (value) {
                          setState(() {
                            mensual = value!;
                            //anual = anios.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
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
    transacciones.clear();
    anios.clear();
    meses.clear();
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('GET', Uri.parse(dataUrl));
    request.bodyFields = {'anio': anual, 'mes': mensual};

    request.headers.addAll(headers);

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List lista = jsonDecode(response.body);

    for (var element in lista) {
      transacciones.add(TransaccionMensual(
          double.parse(element['valor'].toString()), element['dia']));
    }

    var request2 =
        http.Request('GET', Uri.parse('http://192.168.0.7:8474/anios'));

    http.StreamedResponse responseStream2 = await request2.send();
    var response2 = await http.Response.fromStream(responseStream2);

    List lista2 = jsonDecode(response2.body);

    for (var element in lista2) {
      anios.add(element['anios'].toString());
    }

    var request3 =
        http.Request('GET', Uri.parse('http://192.168.0.7:8474/meses'));
    request3.bodyFields = {
      'anio': anual,
    };
    http.StreamedResponse responseStream3 = await request3.send();
    var response3 = await http.Response.fromStream(responseStream3);

    List lista3 = jsonDecode(response3.body);

    for (var element in lista3) {
      meses.add(element['meses'].toString());
    }

    mayor = getMayor(transacciones);
    return transacciones;
  }

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
