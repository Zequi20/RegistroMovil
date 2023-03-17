import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import '../models/model_sedes.dart';
import '../widgets/transacciones_chart_anual.dart';
// ignore: unused_import
import '../widgets/transacciones_chart_anual_sedes.dart';
import '../widgets/transacciones_chart_mensual.dart';
// ignore: unused_import
import '../widgets/transacciones_chart_mensual_sedes.dart';

class GraphSelectScreen extends StatefulWidget {
  const GraphSelectScreen({super.key});

  @override
  State<GraphSelectScreen> createState() => _GraphSelectScreenState();
}

class _GraphSelectScreenState extends State<GraphSelectScreen> {
  List<int> meses = [];
  List<int> mesesSuc = [];

  List<Sede> sedes = [];
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
  List<int> aniosSuc = [];

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

  int anioPorDiaSucursal = DateTime.now().year;
  int mesPorDiaSucursal = DateTime.now().month;
  int anioPorMesSucursal = DateTime.now().year;
  int sede = 1;
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
        centerTitle: true,
        title: const Text(
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
        ),
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
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
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
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Dias del mes...',
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
                                          'Meses del año...',
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
                              ), /*
                              const Divider(
                                color: Colors.white,
                                height: 64,
                              ),
                              const Text(
                                'Por sucursal',
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
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  decoration: dropDownStyle,
                                  dropdownColor: bfColorBtn,
                                  value: sede,
                                  items: List.generate(
                                      sedes.length,
                                      (index) => DropdownMenuItem(
                                          value: sedes[index].idSede,
                                          child: Text(
                                            sedes[index].nombreSede,
                                            style: bfTextStyle,
                                          ))),
                                  onChanged: (value) {
                                    setState(() {
                                      sede = value!;
                                    });
                                  },
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
                                          'Dias del mes...',
                                          style: bfTitleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                        const Divider(
                                          height: 8,
                                        ),
                                        DropdownButtonFormField(
                                          dropdownColor: bfColorBtn,
                                          decoration: dropDownStyle,
                                          value: anioPorDiaSucursal,
                                          items: List.generate(
                                              aniosSuc.length,
                                              (index) => DropdownMenuItem(
                                                  value: aniosSuc[index],
                                                  child: Text(
                                                    '${aniosSuc[index]}',
                                                    style: bfTextStyle,
                                                  ))),
                                          onChanged: (value) {
                                            setState(() {
                                              anioPorDiaSucursal = value!;
                                            });
                                          },
                                        ),
                                        const Divider(
                                          height: 8,
                                        ),
                                        DropdownButtonFormField(
                                          dropdownColor: bfColorBtn,
                                          decoration: dropDownStyle,
                                          value: mesPorDiaSucursal,
                                          items: List.generate(
                                              mesesSuc.length,
                                              (index) => DropdownMenuItem(
                                                  value: mesesSuc[index],
                                                  child: Text(
                                                    mesesNombres[
                                                        mesesSuc[index] - 1],
                                                    style: bfTextStyle,
                                                  ))),
                                          onChanged: (value) {
                                            setState(() {
                                              mesPorDiaSucursal = value!;
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
                                                          child:
                                                              BarChartTransaccionesMensualesSede(
                                                            anual:
                                                                anioPorDiaSucursal
                                                                    .toString(),
                                                            mensual:
                                                                mesPorDiaSucursal
                                                                    .toString(),
                                                            sede:
                                                                sede.toString(),
                                                          ),
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
                                          'Meses del año...',
                                          style: bfTitleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                        const Divider(
                                          height: 8,
                                        ),
                                        DropdownButtonFormField(
                                          decoration: dropDownStyle,
                                          dropdownColor: bfColorBtn,
                                          value: anioPorMesSucursal,
                                          items: List.generate(
                                              aniosSuc.length,
                                              (index) => DropdownMenuItem(
                                                  value: aniosSuc[index],
                                                  child: Text(
                                                    '${aniosSuc[index]}',
                                                    style: bfTextStyle,
                                                  ))),
                                          onChanged: (value) {
                                            setState(() {
                                              anioPorMesSucursal = value!;
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
                                                          child:
                                                              BarChartTransaccionesSede(
                                                            anual:
                                                                anioPorMesSucursal
                                                                    .toString(),
                                                            sede:
                                                                sede.toString(),
                                                          ),
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
                              ),*/
                            ],
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 8,
                              ),
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
    sedes.clear();
    aniosSuc.clear();
    mesesSuc.clear();

    var request2 =
        http.Request('GET', Uri.parse('http://132.255.166.73:8474/anios'));

    http.StreamedResponse responseStream2 = await request2.send();
    var response2 = await http.Response.fromStream(responseStream2);

    List list2 = json.decode(response2.body);

    for (var element in list2) {
      anios.add(element['anios']);
    }

    var request =
        http.Request('GET', Uri.parse('http://132.255.166.73:8474/meses'));
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
//sedes
    var request3 =
        http.Request('GET', Uri.parse('http://132.255.166.73:8474/sedes'));

    http.StreamedResponse responseStream3 = await request3.send();
    var response3 = await http.Response.fromStream(responseStream3);

    List list3 = json.decode(response3.body);

    for (var element in list3) {
      sedes.add(Sede.fromJson(element));
    }

//Anio por sede

    var requestAnio = http.Request(
        'GET', Uri.parse('http://132.255.166.73:8474/anios_por_sede'));
    requestAnio.bodyFields = {'sede': sede.toString()};
    http.StreamedResponse responseStreamAnio = await requestAnio.send();
    var responseAnio = await http.Response.fromStream(responseStreamAnio);

    List listAnio = json.decode(responseAnio.body);

    for (var element in listAnio) {
      aniosSuc.add(element['anios']);
    }

    if (aniosSuc.contains(anioPorDiaSucursal) == false) {
      anioPorDiaSucursal = aniosSuc.first;
    }
//Meses por sede

    var requestMes = http.Request(
        'GET', Uri.parse('http://132.255.166.73:8474/meses_por_sede'));
    requestMes.bodyFields = {
      'anio': anioPorDia.toString(),
      'sede': sede.toString()
    };

    http.StreamedResponse responseStreamMes = await requestMes.send();
    var responseMes = await http.Response.fromStream(responseStreamMes);

    List listMes = json.decode(responseMes.body);

    for (var element in listMes) {
      mesesSuc.add(element['meses']);
    }

    if (mesesSuc.contains(mesPorDiaSucursal) == false) {
      mesPorDiaSucursal = mesesSuc.first;
    }

    return list2;
  }
}
