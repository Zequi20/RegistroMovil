import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bio_farm/models/model_funcionario_pagos.dart';
import 'package:bio_farm/widgets/modal_pagos.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PagosForm extends StatefulWidget {
  const PagosForm({super.key});

  @override
  State<PagosForm> createState() => _PagosFormState();
}

class _PagosFormState extends State<PagosForm> {
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
  TextEditingController plusFuncionario = TextEditingController(text: '0');

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

    return Column(
      children: [
        Expanded(
          flex: 14,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: idFuncionario,
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Id Funcionario')),
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: getPagosData(
                                            'http://132.255.166.73:8474/funcionarios_pago'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          return snapshot.hasData
                                              ? ModalPagos(
                                                  listaFuncionarios:
                                                      snapshot.data,
                                                  idTextController:
                                                      idFuncionario,
                                                  idSedeTextController: idSede,
                                                  funcionarioTextController:
                                                      nombreFuncionario,
                                                  sueldoTextController:
                                                      sueldoFuncionario,
                                                  nombreSedeTextController:
                                                      sedeFuncionario,
                                                )
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: colorPrincipal,
                                                  ),
                                                );
                                        },
                                      );
                                    });
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: idSede,
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              decoration:
                                  const InputDecoration(label: Text('Id Sede')),
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: getPagosData(
                                            'http://132.255.166.73:8474/funcionarios_pago'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          return snapshot.hasData
                                              ? ModalPagos(
                                                  listaFuncionarios:
                                                      snapshot.data,
                                                  idTextController:
                                                      idFuncionario,
                                                  idSedeTextController: idSede,
                                                  funcionarioTextController:
                                                      nombreFuncionario,
                                                  sueldoTextController:
                                                      sueldoFuncionario,
                                                  nombreSedeTextController:
                                                      sedeFuncionario,
                                                )
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: colorPrincipal,
                                                  ),
                                                );
                                        },
                                      );
                                    });
                                setState(() {});
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: nombreFuncionario,
                              readOnly: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'\d'))
                              ],
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Nombre Funcionario')),
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: getPagosData(
                                            'http://132.255.166.73:8474/funcionarios_pago'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          return snapshot.hasData
                                              ? ModalPagos(
                                                  listaFuncionarios:
                                                      snapshot.data,
                                                  idTextController:
                                                      idFuncionario,
                                                  idSedeTextController: idSede,
                                                  funcionarioTextController:
                                                      nombreFuncionario,
                                                  sueldoTextController:
                                                      sueldoFuncionario,
                                                  nombreSedeTextController:
                                                      sedeFuncionario,
                                                )
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: colorPrincipal,
                                                  ),
                                                );
                                        },
                                      );
                                    });
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: sedeFuncionario,
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Sede Funcionario')),
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: getPagosData(
                                            'http://132.255.166.73:8474/funcionarios_pago'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          return snapshot.hasData
                                              ? ModalPagos(
                                                  listaFuncionarios:
                                                      snapshot.data,
                                                  idTextController:
                                                      idFuncionario,
                                                  idSedeTextController: idSede,
                                                  funcionarioTextController:
                                                      nombreFuncionario,
                                                  sueldoTextController:
                                                      sueldoFuncionario,
                                                  nombreSedeTextController:
                                                      sedeFuncionario,
                                                )
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: colorPrincipal,
                                                  ),
                                                );
                                        },
                                      );
                                    });
                                setState(() {});
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextField(
                        controller: sueldoFuncionario,
                        readOnly: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'\d'))
                        ],
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            label: Text('Sueldo Funcionario')),
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return FutureBuilder(
                                  future: getPagosData(
                                      'http://132.255.166.73:8474/funcionarios_pago'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    return snapshot.hasData
                                        ? ModalPagos(
                                            listaFuncionarios: snapshot.data,
                                            idTextController: idFuncionario,
                                            idSedeTextController: idSede,
                                            funcionarioTextController:
                                                nombreFuncionario,
                                            sueldoTextController:
                                                sueldoFuncionario,
                                            nombreSedeTextController:
                                                sedeFuncionario,
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                              color: colorPrincipal,
                                            ),
                                          );
                                  },
                                );
                              });
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: plusFuncionario,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            label: Text('Plus Funcionario')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12),
                      child: TextField(
                        controller: fechaPago,
                        onTap: () async {
                          fechaPago.text = await showDatePicker(
                                  cancelText: 'Cancelar',
                                  confirmText: 'Aceptar',
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000, 1, 1),
                                  lastDate: DateTime.now())
                              .then((value) {
                            if (value != null) {
                              return DateFormat('yyyy-MM-dd').format(value);
                            } else {
                              return fechaPago.text;
                            }
                          });
                        },
                        readOnly: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'\d'))
                        ],
                        keyboardType: TextInputType.text,
                        decoration:
                            const InputDecoration(label: Text('Fecha pago')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12),
                      child: TextField(
                        maxLength: 50,
                        controller: comentarioPago,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            label: Text('Comentario pago')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12),
                      child: getTotal(
                          titleTextStyle, plusFuncionario, sueldoFuncionario),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: FilledButton(
                          onPressed: () async {
                            pagosReg(
                                cardTextStyle, cardSubTextStyle, cardShape);
                          },
                          child: Text(
                            'Registrar pago',
                            style: cardTextStyle,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: Container(
          decoration: const BoxDecoration(color: Colors.white),
        )),
      ],
    );
  }

  void pagosReg(var cardTextStyle, var cardSubTextStyle, var cardShape) {
    if (idFuncionario.text.trim() != '') {
      showDialog(
          context: context,
          builder: (buildContext) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      var request = http.Request(
                          'POST',
                          Uri.parse(
                              'http://132.255.166.73:8474/insertar_pago'));
                      request.bodyFields = {
                        'id_funcionario': idFuncionario.text,
                        'id_sede': idSede.text,
                        'salario_registro': sueldoFuncionario.text,
                        'plus_registro': plusFuncionario.text,
                        'fecha_registro': fechaPago.text,
                        'comentario_registro': comentarioPago.text,
                      };

                      await request.send().then((value) {
                        if (value.statusCode == 200) {
                          return showDialog(
                              context: context,
                              builder: (buildContext) {
                                return AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text(
                                          'Aceptar',
                                          style: cardSubTextStyle,
                                        ))
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                  shape: cardShape,
                                  backgroundColor: colorSecundario,
                                  titleTextStyle: cardTextStyle,
                                  contentTextStyle: cardSubTextStyle,
                                  icon: Icon(
                                    Icons.check,
                                    color: colorPrincipal,
                                  ),
                                  content: const Text(
                                    'Operacion realizada con exito',
                                    textAlign: TextAlign.center,
                                  ),
                                  title: const Text(
                                      'Confirmacion de la operacion'),
                                );
                              });
                        } else {
                          return showDialog(
                              context: context,
                              builder: (buildContext) {
                                return AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text(
                                          'Aceptar',
                                          style: cardSubTextStyle,
                                        ))
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                  shape: cardShape,
                                  backgroundColor: colorSecundario,
                                  titleTextStyle: cardTextStyle,
                                  contentTextStyle: cardSubTextStyle,
                                  icon: Icon(
                                    Icons.error,
                                    color: colorPrincipal,
                                  ),
                                  content: const Text(
                                    'Operacion no realizada',
                                    textAlign: TextAlign.center,
                                  ),
                                  title: const Text('Error en la operacion'),
                                );
                              });
                        }
                      });
                    },
                    child: Text(
                      'Si, registrar',
                      style: cardSubTextStyle,
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text(
                      'No registrar',
                      style: cardSubTextStyle,
                    ))
              ],
              actionsAlignment: MainAxisAlignment.center,
              shape: cardShape,
              backgroundColor: colorSecundario,
              titleTextStyle: cardTextStyle,
              contentTextStyle: cardSubTextStyle,
              icon: Icon(
                Icons.error,
                color: colorPrincipal,
              ),
              content: const Text(
                'Esta accion no se puede deshacer, esta seguro?',
                textAlign: TextAlign.center,
              ),
              title: const Text('Registrar pago'),
            );
          });
      /*   */
    } else {
      showDialog(
          context: context,
          builder: (buildContext) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text(
                      'Aceptar',
                      style: cardSubTextStyle,
                    ))
              ],
              actionsAlignment: MainAxisAlignment.center,
              shape: cardShape,
              backgroundColor: colorSecundario,
              titleTextStyle: cardTextStyle,
              contentTextStyle: cardSubTextStyle,
              icon: Icon(
                Icons.error,
                color: colorPrincipal,
              ),
              content: const Text(
                'Los campos del funcionario son obligatorios, completelos y vuelva a intentarlo',
                textAlign: TextAlign.center,
              ),
              title: const Text('Campos obligatorios'),
            );
          });
    }
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
