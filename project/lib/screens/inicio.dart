import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class ScreenInicio extends StatefulWidget {
  const ScreenInicio({super.key});

  @override
  State<ScreenInicio> createState() => _ScreenInicioState();
}

class _ScreenInicioState extends State<ScreenInicio> {
  var colorResaltante = Colors.indigo.shade900;
  var colorSecundario = Colors.blue.shade500;
  var colorPrincipal = Colors.white;
  var shadowPrincipal =
      const Shadow(color: Colors.black38, offset: Offset(1, 1));

  String begin = '2022-01-01';
  String end = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    var titleTextStyle = TextStyle(
      color: colorResaltante,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
    var cardTextStyle = TextStyle(
        color: colorPrincipal,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        shadows: [shadowPrincipal]);
    var cardSubTextStyle = TextStyle(
        color: colorPrincipal,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        shadows: [shadowPrincipal]);
    var cardShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: colorResaltante));
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorPrincipal,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.replay_rounded)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [colorPrincipal, colorSecundario])),
        ),
        iconTheme: IconThemeData(color: colorResaltante),
        elevation: 0,
        centerTitle: true,
        title: Text(
          style: titleTextStyle,
          'INICIO',
          textAlign: TextAlign.center,
        ),
        backgroundColor: colorPrincipal,
        actions: [
          IconButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              icon: const Icon(
                Icons.exit_to_app,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getChartData('http://132.255.166.73:8474/general'),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  NumberFormat f = NumberFormat("#,##0.00", "es_AR");

                  if (snapshot.hasData) {
                    double total = snapshot.data[0] + snapshot.data[1];
                    String ingresos = '${f.format(snapshot.data[1])} Gs';
                    String egresos = '${f.format(snapshot.data[0])} Gs';
                    String ganancias =
                        '${f.format(snapshot.data[1] - snapshot.data[0])} Gs';
                    String porcIngresos =
                        '${f.format((snapshot.data[1] * 100) / (total))}% Ingresos';
                    String porcEgresos =
                        '${f.format((snapshot.data[0] * 100) / (total))}% Gastos';
                    var gananciasColor = colorSecundario;
                    if (snapshot.data[1] - snapshot.data[0] < 0) {
                      gananciasColor = Colors.red;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          ListTile(
                            shape: cardShape,
                            contentPadding: const EdgeInsets.all(8),
                            leading: Icon(
                              Icons.info,
                              color: colorPrincipal,
                              size: 45,
                              shadows: [shadowPrincipal],
                            ),
                            title: Text(
                              'Ingresos',
                              style: cardTextStyle,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ingresos,
                                style: cardTextStyle,
                              ),
                            ),
                            tileColor: colorSecundario,
                          ),
                          Divider(
                            color: colorPrincipal,
                            height: 8,
                          ),
                          ListTile(
                            shape: cardShape,
                            contentPadding: const EdgeInsets.all(8),
                            leading: Icon(
                              Icons.info,
                              color: colorPrincipal,
                              size: 45,
                              shadows: [shadowPrincipal],
                            ),
                            title: Text(
                              'Gastos',
                              style: cardTextStyle,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                egresos,
                                style: cardTextStyle,
                              ),
                            ),
                            tileColor: colorSecundario,
                          ),
                          Divider(
                            color: colorPrincipal,
                            height: 8,
                          ),
                          ListTile(
                            shape: cardShape,
                            contentPadding: const EdgeInsets.all(8),
                            leading: Icon(
                              Icons.info,
                              color: colorPrincipal,
                              size: 45,
                              shadows: [shadowPrincipal],
                            ),
                            title: Text(
                              'Ganancias',
                              style: cardTextStyle,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ganancias,
                                style: cardTextStyle,
                              ),
                            ),
                            tileColor: gananciasColor,
                          ),
                          Divider(
                            color: colorPrincipal,
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                porcIngresos,
                                style: titleTextStyle,
                                textAlign: TextAlign.center,
                              )),
                              Expanded(
                                  child: Text(
                                porcEgresos,
                                style: titleTextStyle,
                                textAlign: TextAlign.center,
                              ))
                            ],
                          ),
                          AspectRatio(
                            aspectRatio: 1.25,
                            child: PieChart(PieChartData(
                                startDegreeOffset: 30,
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      radius: 130,
                                      value: snapshot.data[0],
                                      showTitle: true,
                                      color: colorResaltante,
                                      title: 'Gastos',
                                      titleStyle: cardTextStyle),
                                  PieChartSectionData(
                                      radius: 130,
                                      value: snapshot.data[1],
                                      showTitle: true,
                                      color: colorSecundario,
                                      title: 'Ingresos',
                                      titleStyle: cardTextStyle)
                                ])),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: FilledButton(
                                      onPressed: () async {
                                        begin = await showDatePicker(
                                                cancelText: 'Cancelar',
                                                confirmText: 'Aceptar',
                                                initialEntryMode:
                                                    DatePickerEntryMode
                                                        .calendarOnly,
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2022, 1, 1),
                                                lastDate: DateTime.now())
                                            .then((value) {
                                          if (value != null) {
                                            return DateFormat('yyyy-MM-dd')
                                                .format(value);
                                          } else {
                                            return begin;
                                          }
                                        });
                                        setState(() {});
                                      },
                                      child: Text(
                                        begin,
                                        style: cardSubTextStyle,
                                        textAlign: TextAlign.center,
                                      ))),
                              Expanded(
                                  child: Text(
                                'hasta',
                                style: titleTextStyle,
                                textAlign: TextAlign.center,
                              )),
                              Expanded(
                                  flex: 2,
                                  child: FilledButton(
                                      onPressed: () async {
                                        end = await showDatePicker(
                                                cancelText: 'Cancelar',
                                                confirmText: 'Aceptar',
                                                initialEntryMode:
                                                    DatePickerEntryMode
                                                        .calendarOnly,
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate:
                                                    DateTime.parse(begin),
                                                lastDate: DateTime.now())
                                            .then((value) {
                                          if (value != null) {
                                            return DateFormat('yyyy-MM-dd')
                                                .format(value);
                                          } else {
                                            return end;
                                          }
                                        });
                                        setState(() {});
                                      },
                                      child: Text(
                                        end,
                                        textAlign: TextAlign.center,
                                        style: cardSubTextStyle,
                                      ))),
                            ],
                          ),
                          Divider(
                            color: colorPrincipal,
                            height: 12,
                          ),
                          FilledButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('Sedes');
                              },
                              child: Text(
                                'Gestionar sucursales',
                                style: cardTextStyle,
                              )),
                          Divider(
                            color: colorPrincipal,
                            height: 12,
                          ),
                          FilledButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('Pagos');
                              },
                              child: Text(
                                'Gestionar pago',
                                style: cardTextStyle,
                              ))
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: colorSecundario,
                        strokeWidth: 8,
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    ));
  }

  Future getChartData(String dataUrl) async {
    var request = http.Request('GET', Uri.parse(dataUrl));
    request.bodyFields = {'begin': begin, 'end': end};

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List lista = jsonDecode(response.body);

    List<double> valores = lista.map((e) {
      if (e['SUM(valor_transaccion)'].toString() != 'null') {
        return double.parse(e['SUM(valor_transaccion)'].toString());
      } else {
        return 0.0;
      }
    }).toList();
    if (valores.length < 2) {
      valores.add(0.0);
    }

    return valores;
  }
}
