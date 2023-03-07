import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import '../widgets/transacciones_chart_anual.dart';
// ignore: unused_import
import '../widgets/transacciones_chart_mensual.dart';

class GraphSelectScreen extends StatefulWidget {
  const GraphSelectScreen({super.key});

  @override
  State<GraphSelectScreen> createState() => _GraphSelectScreenState();
}

class _GraphSelectScreenState extends State<GraphSelectScreen> {
  List<int> meses = [];
  List<String> mesesNombres = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  List<int> anios = [];

  var bfColor = Colors.blue.shade600.withOpacity(0.7);
  var bfColorBtn = Colors.indigo.shade900.withOpacity(0.7);
  var bfTextStyle = const TextStyle(
    shadows: [
      Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 12)
    ],
    color: Colors.white,
    fontSize: 16,
  );

  var bfTitleStyle = const TextStyle(
    shadows: [
      Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 12)
    ],
    color: Colors.white,
    fontSize: 18,
  );

  int anioPorDia = DateTime.now().year;
  int mesPorDia = DateTime.now().month;
  int anioPorMes = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    var dropDownStyle = InputDecoration(
      focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      fillColor: bfColorBtn,
      filled: true,
    );
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
          'Generar graficos',
          textAlign: TextAlign.center,
        )),
        backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
      ),
      body: ListView(
        children: [
          Container(
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
              child: FutureBuilder(
                  future: getGral(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.hasData
                        ? Column(
                            children: [
                              const Text(
                                'Generales',
                                style: TextStyle(
                                  shadows: [
                                    Shadow(
                                        color: Colors.black54,
                                        offset: Offset(1, 1),
                                        blurRadius: 4),
                                  ],
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Por dias',
                                          style: bfTitleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                        const Divider(
                                          height: 8,
                                        ),
                                        DropdownButtonFormField(
                                          dropdownColor: bfColorBtn,
                                          decoration: dropDownStyle,
                                          value: anioPorDia,
                                          items: List.generate(
                                              anios.length,
                                              (index) => DropdownMenuItem(
                                                  value: anios[index],
                                                  child: Text(
                                                    '${anios[index]}',
                                                    style: bfTextStyle,
                                                  ))),
                                          onChanged: (value) {
                                            setState(() {
                                              anioPorDia = value!;
                                            });
                                          },
                                        ),
                                        const Divider(
                                          height: 8,
                                        ),
                                        DropdownButtonFormField(
                                          dropdownColor: bfColorBtn,
                                          decoration: dropDownStyle,
                                          value: mesPorDia,
                                          items: List.generate(
                                              meses.length,
                                              (index) => DropdownMenuItem(
                                                  value: meses[index],
                                                  child: Text(
                                                    mesesNombres[
                                                        meses[index] - 1],
                                                    style: bfTextStyle,
                                                  ))),
                                          onChanged: (value) {
                                            setState(() {
                                              mesPorDia = value!;
                                            });
                                          },
                                        ),
                                        const Divider(
                                          height: 5,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      actions: [
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {});
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .picture_as_pdf,
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                      ],
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      backgroundColor: bfColor,
                                                      content: Builder(
                                                          builder: (context) {
                                                        var width =
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width;

                                                        return SizedBox(
                                                          width: width,
                                                          height: width,
                                                          child: BarChartTransaccionesMensuales(
                                                              anual: anioPorDia
                                                                  .toString(),
                                                              mensual: mesPorDia
                                                                  .toString()),
                                                        );
                                                      }),
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              'Generar',
                                              style: bfTextStyle,
                                            ))
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Por meses',
                                          style: bfTitleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                        const Divider(
                                          height: 8,
                                        ),
                                        DropdownButtonFormField(
                                          decoration: dropDownStyle,
                                          dropdownColor: bfColorBtn,
                                          value: anioPorMes,
                                          items: List.generate(
                                              anios.length,
                                              (index) => DropdownMenuItem(
                                                  value: anios[index],
                                                  child: Text(
                                                    '${anios[index]}',
                                                    style: bfTextStyle,
                                                  ))),
                                          onChanged: (value) {
                                            setState(() {
                                              anioPorMes = value!;
                                            });
                                          },
                                        ),
                                        const Divider(
                                          height: 5,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      backgroundColor: bfColor,
                                                      content: Builder(
                                                          builder: (context) {
                                                        var width =
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width;

                                                        return SizedBox(
                                                          width: width,
                                                          height: width,
                                                          child: BarChartTransacciones(
                                                              anual: anioPorMes
                                                                  .toString()),
                                                        );
                                                      }),
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              'Generar',
                                              style: bfTextStyle,
                                            ))
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              backgroundColor: Colors.white,
                              strokeWidth: 8,
                            ),
                          );
                  }))
        ],
      ),
    ));
  }

  Future getGral() async {
    anios.clear();
    meses.clear();
    var request2 =
        http.Request('GET', Uri.parse('http://192.168.0.7:8474/anios'));

    http.StreamedResponse responseStream2 = await request2.send();
    var response2 = await http.Response.fromStream(responseStream2);

    List list2 = json.decode(response2.body);

    for (var element in list2) {
      anios.add(element['anios']);
    }

    var request =
        http.Request('GET', Uri.parse('http://192.168.0.7:8474/meses'));
    request.bodyFields = {
      'anio': anioPorDia.toString(),
    };

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List list = json.decode(response.body);

    for (var element in list) {
      meses.add(element['meses']);
    }

    if (meses.contains(mesPorDia) == false) {
      mesPorDia = meses.first;
    }

    return list2;
  }
}
