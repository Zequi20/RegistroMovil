import 'package:flutter/services.dart';
import 'dart:convert';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
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
    var cardShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: colorResaltante));
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorPrincipal,
      appBar: AppBar(
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
          /* IconButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Colors.indigo.shade900,
              )), */
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
                    String porcIngresos =
                        '${f.format((snapshot.data[1] * 100) / (total))}% Ingresos';
                    String porcEgresos =
                        '${f.format((snapshot.data[0] * 100) / (total))}% Gastos';
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
                                setState(() {});
                              },
                              child: Text(
                                'Gestionar pagos',
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

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List lista = jsonDecode(response.body);

    List<double> valores = lista
        .map((e) => double.parse(e['sum(valor_transaccion)'].toString()))
        .toList();

    return valores;
  }
}
