import 'package:bio_farm/models/model_funcionario_pagos.dart';
import 'package:bio_farm/widgets/pagos_form.dart';
import 'package:bio_farm/widgets/pagos_historial.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class ScreenPagos extends StatefulWidget {
  const ScreenPagos({super.key});

  @override
  State<ScreenPagos> createState() => _ScreenPagosState();
}

class _ScreenPagosState extends State<ScreenPagos> {
  var colorResaltante = Colors.indigo.shade900;
  var colorSecundario = Colors.blue.shade500;
  var colorPrincipal = Colors.white;
  var shadowPrincipal =
      const Shadow(color: Colors.black38, offset: Offset(1, 1));
  TextEditingController idFuncionario = TextEditingController();
  TextEditingController idSede = TextEditingController();
  TextEditingController nombreFuncionario = TextEditingController();
  TextEditingController sedeFuncionario = TextEditingController();
  TextEditingController sueldoFuncionario = TextEditingController(text: '0');
  TextEditingController plusFuncionario = TextEditingController();

  TextEditingController fechaPago = TextEditingController(
      text: DateFormat('yyy-MM-dd').format(DateTime.now()));
  TextEditingController comentarioPago = TextEditingController();
  NumberFormat f = NumberFormat("#,##0.00", "es_AR");
  double total = 0;
  @override
  Widget build(BuildContext context) {
    var titleTextStyle = TextStyle(
      color: colorResaltante,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
    // ignore: unused_local_variable
    var cardTextStyle = TextStyle(
        color: colorPrincipal,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        shadows: [shadowPrincipal]);
    // ignore: unused_local_variable
    var cardSubTextStyle = TextStyle(
        color: colorPrincipal,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        shadows: [shadowPrincipal]);
    // ignore: unused_local_variable
    var cardShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: colorResaltante));
    return DefaultTabController(
      length: 2,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: colorPrincipal,
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(
                icon: Icon(
              Icons.list_alt,
              color: colorResaltante,
            )),
            Tab(
              icon: Icon(
                Icons.history,
                color: colorResaltante,
              ),
            )
          ]),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [colorPrincipal, colorSecundario])),
          ),
          iconTheme: IconThemeData(color: colorResaltante),
          elevation: 15,
          centerTitle: true,
          title: Text(
            style: titleTextStyle,
            'PAGOS',
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
        body: const TabBarView(
          children: [PagosForm(), PagosHistorial()],
        ),
      )),
    );
  }

  void pagosReg(var cardTextStyle, var cardSubTextStyle, var cardShape) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const Icon(Icons.check),
            titleTextStyle: cardTextStyle,
            contentTextStyle: cardSubTextStyle,
            iconColor: colorPrincipal,
            backgroundColor: colorSecundario,
            shape: cardShape,
            title: const Text('Registrar pago'),
            content: const Text(
              'Operacion exitosa',
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  void pagosError(var cardTextStyle, var cardSubTextStyle, var cardShape) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Aceptar',
                    style: cardSubTextStyle,
                  ))
            ],
            icon: const Icon(Icons.cancel),
            titleTextStyle: cardTextStyle,
            contentTextStyle: cardSubTextStyle,
            iconColor: colorPrincipal,
            backgroundColor: colorSecundario,
            shape: cardShape,
            title: const Text('Campos Obligatorios'),
            content: const Text(
              'Por favor complete los campos del funcionario e intentelo de nuevo',
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  Text getTotal(var titleTextStyle, TextEditingController plusFuncionario,
      TextEditingController sueldoFuncionario) {
    double plus = 0;
    double sueldo = 0;
    double total = 0;
    if (plusFuncionario.text.trim() != '') {
      plus = double.parse(plusFuncionario.text);
    }
    if (sueldoFuncionario.text.trim() != '') {
      sueldo = double.parse(sueldoFuncionario.text);
    }
    total = plus + sueldo;
    return Text(
      'Total a pagar ${f.format(total)} Gs',
      style: titleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Future getPagosData(String dataUrl) async {
    var request = http.Request('GET', Uri.parse(dataUrl));

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List lista = jsonDecode(response.body);

    List<ModelFuncionarioPagos> valores = lista.map((e) {
      return ModelFuncionarioPagos(
          e['id_funcionario'],
          e['id_sede'],
          e['nombre_sede'],
          e['nombre_funcionario'],
          double.parse(e['sueldo_funcionario'].toString()));
    }).toList();

    return valores;
  }
}
