import 'dart:convert';
import 'package:bio_farm/models/model_retiro.dart';
import 'package:bio_farm/widgets/modal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/model_funcionario.dart';
import '../screenParams/arguments.dart';

class ScreenRetirosRegistro extends StatefulWidget {
  const ScreenRetirosRegistro({super.key});

  @override
  State<ScreenRetirosRegistro> createState() => _ScreenRetirosRegistroState();
}

class _ScreenRetirosRegistroState extends State<ScreenRetirosRegistro> {
  final DataGridController _dataGridController = DataGridController();
  var link = 'http://132.255.166.73:8474/retiros';

  bool visible = false;
  Icon searchIcon = const Icon(Icons.search);

  List<ModelRetiro> _transactions = [];
  List<ModelFuncionario> _funcionarios = [];
  late TransactionDataSource _transactionDataSource;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GestionArguments;
    var curDate = DateTime.now();

    var idFuncionarioController = TextEditingController();

    var funcionarioController = TextEditingController();
    var valorController = TextEditingController();
    var fechaController =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(curDate));
    var horaController =
        TextEditingController(text: DateFormat.Hms().format(curDate));
    var motivoController = TextEditingController();

    var idFuncionarioControllerEdit = TextEditingController();
    var funcionarioControllerEdit = TextEditingController();
    var valorControllerEdit = TextEditingController();
    var fechaControllerEdit = TextEditingController();
    var horaControllerEdit = TextEditingController();
    var motivoControllerEdit = TextEditingController();

    var colorPrincipal = Colors.white;
    var colorSecundario = Colors.blue.shade500;
    var colorResaltante = Colors.indigo.shade900;
    var shadowPrincipal =
        const Shadow(color: Colors.black38, offset: Offset(1, 1));

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
    var titleTextStyle = TextStyle(
      color: colorResaltante,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
    return SafeArea(
        child: Scaffold(
      floatingActionButton: Opacity(
        opacity: 0.7,
        child: Wrap(
            direction: Axis.horizontal,
            spacing: 6.5,
            children: getActions(
                args,
                _transactions,
                funcionarioController,
                idFuncionarioController,
                valorController,
                fechaController,
                horaController,
                motivoController,
                idFuncionarioControllerEdit,
                funcionarioControllerEdit,
                valorControllerEdit,
                fechaControllerEdit,
                horaControllerEdit,
                motivoControllerEdit)),
      ),
      backgroundColor: colorPrincipal,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [colorPrincipal, colorSecundario])),
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: colorResaltante),
        centerTitle: true,
        title: Text(
          'Retiros ${args.nombreSede}',
          style: titleTextStyle,
        ),
        backgroundColor: colorPrincipal,
      ),
      body: FutureBuilder(
        future: getTransaccionData(link, args),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? SfDataGrid(
                  onCellTap: (details) {
                    if (details.rowColumnIndex.rowIndex != 0) {
                      int selectedRowIndex =
                          details.rowColumnIndex.rowIndex - 1;
                      var row = _transactionDataSource.effectiveRows
                          .elementAt(selectedRowIndex);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Registro ${row.getCells()[0].value}',
                                textAlign: TextAlign.center,
                              ),
                              content: Wrap(
                                direction: Axis.vertical,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                        'Motivo: ${row.getCells()[6].value}'),
                                  ),
                                  Text('Fecha: ${row.getCells()[4].value}'),
                                  Text(
                                      'Funcionario: ${row.getCells()[1].value}'),
                                  Text('Valor: ${row.getCells()[3].value}'),
                                ],
                              ),
                              titleTextStyle: cardTextStyle,
                              contentTextStyle: cardSubTextStyle,
                              iconColor: colorPrincipal,
                              backgroundColor: colorSecundario,
                              shape: cardShape,
                            );
                          });
                    }
                  },
                  frozenColumnsCount: 1,
                  allowSorting: true,
                  allowFiltering: true,
                  showCheckboxColumn: true,
                  isScrollbarAlwaysShown: true,
                  controller: _dataGridController,
                  selectionMode: SelectionMode.multiple,
                  source: _transactionDataSource,
                  columns: getColumns(),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue.shade600.withOpacity(0.7),
                    backgroundColor: colorPrincipal,
                    strokeWidth: 8,
                  ) /* CircularProgressIndicator(
                    strokeWidth: 3,
                  ) */
                  ,
                );
        },
      ),
    ));
  }

  Future getTransaccionData(String url, GestionArguments args) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('GET', Uri.parse(url));
    request.bodyFields = {'id_sede': args.idSede.toString()};
    request.headers.addAll(headers);

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List list = json.decode(response.body);

    _transactions = listToModel(list);

    _transactionDataSource = TransactionDataSource(_transactions);

    return _transactionDataSource;
  }

  Future getFuncionarioData(GestionArguments args) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'GET', Uri.parse('http://132.255.166.73:8474/funcionarios'));
    request.bodyFields = {'id_sede': args.idSede.toString()};
    request.headers.addAll(headers);

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List list = json.decode(response.body);

    _funcionarios = listToFuncModel(list);

    return _funcionarios;
  }

  List<ModelRetiro> listToModel(List mapa) {
    List<ModelRetiro> lista = [];
    for (var v in mapa) {
      lista.add(ModelRetiro.fromJson(v));
    }

    return lista;
  }

  List<ModelFuncionario> listToFuncModel(List mapa) {
    List<ModelFuncionario> lista = [];
    for (var v in mapa) {
      lista.add(ModelFuncionario.fromJson(v));
    }

    return lista;
  }

  List<GridColumn> getColumns() {
    return [
      GridColumn(
          columnName: 'Id',
          allowFiltering: true,
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('ID'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Funcionario',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Funcionario'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Id Funcionario',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Id Funcionario'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Valor',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Valor'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Fecha',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Fecha'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Hora',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Hora'),
          )),
      GridColumn(
          allowFiltering: true,
          columnName: 'Motivo',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Motivo'),
          ))
    ];
  }

  List<Widget> getActions(
      args,
      listaDropDown,
      funcionarioController,
      idFuncionarioController,
      valorController,
      fechaController,
      horaController,
      motivoController,
      idFuncionarioControllerEdit,
      funcionarioControllerEdit,
      valorControllerEdit,
      fechaControllerEdit,
      horaControllerEdit,
      motivoControllerEdit) {
    var colorPrincipal = Colors.white;
    var colorSecundario = Colors.blue.shade500;
    var colorResaltante = Colors.indigo.shade900;
    var shadowPrincipal =
        const Shadow(color: Colors.black38, offset: Offset(1, 1));

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

    return [
      FloatingActionButton(
          elevation: 0,
          heroTag: 'btn_add',
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: cardShape,
                elevation: 0.5,
                context: context,
                builder: ((context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Form(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                color: colorSecundario),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'Agregar al registro',
                                  style: cardTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return FutureBuilder(
                                          future: getFuncionarioData(args),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            return snapshot.hasData
                                                ? ModalList(
                                                    listaFuncionarios:
                                                        _funcionarios,
                                                    idTextController:
                                                        idFuncionarioController,
                                                    funcionarioTextController:
                                                        funcionarioController)
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: colorPrincipal,
                                                    ),
                                                  );
                                          },
                                        );
                                      });
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'\d')),
                                ],
                                enabled: true,
                                readOnly: true,
                                controller: idFuncionarioController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    label: Text('Id del funcionario')),
                              )),
                              const Divider(
                                indent: 5,
                              ),
                              Expanded(
                                  child: TextFormField(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return FutureBuilder(
                                          future: getFuncionarioData(args),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            return snapshot.hasData
                                                ? ModalList(
                                                    listaFuncionarios:
                                                        _funcionarios,
                                                    idTextController:
                                                        idFuncionarioController,
                                                    funcionarioTextController:
                                                        funcionarioController)
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: colorPrincipal,
                                                    ),
                                                  );
                                          },
                                        );
                                      });
                                },
                                readOnly: true,
                                controller: funcionarioController,
                                decoration: const InputDecoration(
                                    label: Text('Nombre del funcionario')),
                              ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'\d')),
                            ],
                            controller: valorController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text('Valor del retiro (Guaranies)')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            onTap: () async {
                              fechaController.text = await showDatePicker(
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
                                  return fechaController.text;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Fecha del retiro'),
                            readOnly: true,
                            controller: fechaController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            onTap: () async {
                              horaController.text = await showTimePicker(
                                      helpText: 'Fijar hora del Retiro',
                                      cancelText: 'Cancelar',
                                      confirmText: 'Aceptar',
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.dialOnly)
                                  .then((value) {
                                if (value != null) {
                                  return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
                                } else {
                                  return horaController.text;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Hora del retiro'),
                            readOnly: true,
                            controller: horaController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            maxLength: 50,
                            controller: motivoController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                label: Text('Motivo del retiro')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: FilledButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                titleTextStyle: cardTextStyle,
                                                contentTextStyle:
                                                    cardSubTextStyle,
                                                backgroundColor:
                                                    colorSecundario,
                                                shape: cardShape,
                                                iconColor: colorPrincipal,
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                          style:
                                                              cardSubTextStyle,
                                                          'Cancelar')),
                                                  TextButton(
                                                      onPressed: () {
                                                        if (idFuncionarioController
                                                                .text ==
                                                            '') {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  titleTextStyle:
                                                                      cardTextStyle,
                                                                  contentTextStyle:
                                                                      cardSubTextStyle,
                                                                  shape:
                                                                      cardShape,
                                                                  iconColor:
                                                                      colorPrincipal,
                                                                  backgroundColor:
                                                                      colorSecundario,
                                                                  actions: [
                                                                    TextButton(
                                                                        child:
                                                                            Text(
                                                                          'Aceptar',
                                                                          style:
                                                                              cardSubTextStyle,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        })
                                                                  ],
                                                                  title: Text(
                                                                    'Campo Id del funcionario vacio',
                                                                    style:
                                                                        cardTextStyle,
                                                                  ),
                                                                  content: Text(
                                                                    'Introduzca el identificador del funcionario asociado al retiro',
                                                                    style:
                                                                        cardTextStyle,
                                                                  ),
                                                                );
                                                              });
                                                        } else {
                                                          if (motivoController
                                                                  .text
                                                                  .toString()
                                                                  .trim() ==
                                                              '') {
                                                            motivoController
                                                                    .text =
                                                                '(Sin motivo)';
                                                          }

                                                          if (valorController
                                                                  .text ==
                                                              '') {
                                                            valorController
                                                                .text = '0';
                                                          }

                                                          var headers = {
                                                            'Content-Type':
                                                                'application/x-www-form-urlencoded'
                                                          };
                                                          var request =
                                                              http.Request(
                                                                  'POST',
                                                                  Uri.parse(
                                                                      'http://132.255.166.73:8474/retiros/agregar'));
                                                          request.bodyFields = {
                                                            'id_funcionario':
                                                                idFuncionarioController
                                                                    .text
                                                                    .toString(),
                                                            'valor_retiro':
                                                                valorController
                                                                    .text,
                                                            'fecha_retiro':
                                                                fechaController
                                                                    .text,
                                                            'hora_retiro':
                                                                horaController
                                                                    .text,
                                                            'motivo_retiro':
                                                                motivoController
                                                                    .text
                                                          };
                                                          request.headers
                                                              .addAll(headers);

                                                          request.send();

                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Text(
                                                        'Agregar',
                                                        style: cardSubTextStyle,
                                                      ))
                                                ],
                                                icon: const Icon(Icons.publish),
                                                title: const Text(
                                                    'Confirmar Operacion'),
                                                content: const Text(
                                                    'Seguro que desea agregar cambios al registro?'),
                                              );
                                            });
                                      },
                                      child: Text(
                                        'Agregar',
                                        style: cardSubTextStyle,
                                      ))),
                              const Divider(
                                indent: 5.0,
                              ),
                              Expanded(
                                  child: FilledButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                titleTextStyle: cardTextStyle,
                                                contentTextStyle:
                                                    cardSubTextStyle,
                                                iconColor: colorPrincipal,
                                                backgroundColor:
                                                    colorSecundario,
                                                shape: cardShape,
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Cancelar',
                                                        style: cardSubTextStyle,
                                                      )),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Descartar',
                                                        style:
                                                            cardSubTextStyle),
                                                  )
                                                ],
                                                icon: const Icon(
                                                    Icons.unpublished),
                                                title: Text(
                                                  'Descartar Operacion',
                                                  style: cardTextStyle,
                                                ),
                                                content: Text(
                                                  'Seguro que desea descartar la operacion?',
                                                  style: cardTextStyle,
                                                ),
                                              );
                                            });
                                      },
                                      child: Text(
                                        'Descartar',
                                        style: cardSubTextStyle,
                                      )))
                            ],
                          ),
                        ),
                      ],
                    )),
                  );
                }));
          },
          backgroundColor: colorSecundario,
          child: Icon(Icons.playlist_add, color: colorPrincipal)),
      FloatingActionButton(
          elevation: 0,
          heroTag: 'btn_edit',
          onPressed: () {
            if (_dataGridController.selectedRows.isNotEmpty) {
              if (_dataGridController.selectedRows.length > 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        titleTextStyle: cardTextStyle,
                        contentTextStyle: cardSubTextStyle,
                        shape: cardShape,
                        iconColor: colorPrincipal,
                        backgroundColor: colorSecundario,
                        actions: [
                          TextButton(
                              child: Text(
                                'Aceptar',
                                style: cardSubTextStyle,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        title: Text(
                          'Seleccione un solo registro',
                          style: cardTextStyle,
                        ),
                        content: Text(
                          'Esta operacion solo puede realizarse con un registro a la vez, porfavor seleccione un solo registro',
                          style: cardTextStyle,
                        ),
                      );
                    });
              } else {
                var selection =
                    _dataGridController.selectedRows.first.getCells();
                int regId = selection[0].value;
                funcionarioControllerEdit.text = selection[1].value.toString();
                idFuncionarioControllerEdit.text =
                    selection[2].value.toString();
                valorControllerEdit.text = selection[3].value.toString();
                fechaControllerEdit.text = selection[4].value.toString();
                horaControllerEdit.text = selection[5].value.toString();
                motivoControllerEdit.text = selection[6].value.toString();

                showModalBottomSheet(
                    isScrollControlled: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: cardShape,
                    elevation: 0.5,
                    context: context,
                    builder: ((context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Form(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    color: colorSecundario),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      'Modificar registro ($regId)',
                                      style: cardTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return FutureBuilder(
                                              future: getFuncionarioData(args),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                return snapshot.hasData
                                                    ? ModalList(
                                                        listaFuncionarios:
                                                            _funcionarios,
                                                        idTextController:
                                                            idFuncionarioControllerEdit,
                                                        funcionarioTextController:
                                                            funcionarioControllerEdit)
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: colorPrincipal,
                                                        ),
                                                      );
                                              },
                                            );
                                          });
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'\d')),
                                    ],
                                    enabled: true,
                                    readOnly: true,
                                    controller: idFuncionarioControllerEdit,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        label: Text('Id del funcionario')),
                                  )),
                                  const Divider(
                                    indent: 5,
                                  ),
                                  Expanded(
                                      child: TextFormField(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return FutureBuilder(
                                              future: getFuncionarioData(args),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                return snapshot.hasData
                                                    ? ModalList(
                                                        listaFuncionarios:
                                                            _funcionarios,
                                                        idTextController:
                                                            idFuncionarioControllerEdit,
                                                        funcionarioTextController:
                                                            funcionarioControllerEdit)
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: colorPrincipal,
                                                        ),
                                                      );
                                              },
                                            );
                                          });
                                    },
                                    readOnly: true,
                                    controller: funcionarioControllerEdit,
                                    decoration: const InputDecoration(
                                        label: Text('Nombre del funcionario')),
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'\d')),
                                ],
                                controller: valorControllerEdit,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    label:
                                        Text('Valor del retiro (Guaranies)')),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TextField(
                                onTap: () async {
                                  fechaControllerEdit
                                      .text = await showDatePicker(
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
                                      return DateFormat('yyyy-MM-dd')
                                          .format(value);
                                    } else {
                                      return fechaControllerEdit.text;
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Fecha del retiro'),
                                readOnly: true,
                                controller: fechaControllerEdit,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TextField(
                                onTap: () async {
                                  horaControllerEdit.text =
                                      await showTimePicker(
                                              helpText: 'Fijar hora del Retiro',
                                              cancelText: 'Cancelar',
                                              confirmText: 'Aceptar',
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                              initialEntryMode:
                                                  TimePickerEntryMode.dialOnly)
                                          .then((value) {
                                    if (value != null) {
                                      return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
                                    } else {
                                      return horaControllerEdit.text;
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Hora del retiro'),
                                readOnly: true,
                                controller: horaControllerEdit,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TextField(
                                maxLength: 50,
                                controller: motivoControllerEdit,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    label: Text('Motivo del retiro')),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: FilledButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    titleTextStyle:
                                                        cardTextStyle,
                                                    contentTextStyle:
                                                        cardSubTextStyle,
                                                    backgroundColor:
                                                        colorSecundario,
                                                    shape: cardShape,
                                                    iconColor: colorPrincipal,
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Cancelar',
                                                            style:
                                                                cardSubTextStyle),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          if (valorControllerEdit
                                                                  .text ==
                                                              '') {
                                                            valorControllerEdit
                                                                .text = '0';
                                                          }
                                                          var headers = {
                                                            'Content-Type':
                                                                'application/x-www-form-urlencoded'
                                                          };
                                                          var request =
                                                              http.Request(
                                                                  'POST',
                                                                  Uri.parse(
                                                                      'http://132.255.166.73:8474/retiros/editar'));
                                                          request.bodyFields = {
                                                            'id_retiro': regId
                                                                .toString(),
                                                            'id_funcionario':
                                                                idFuncionarioControllerEdit
                                                                    .text,
                                                            'valor_retiro':
                                                                valorControllerEdit
                                                                    .text,
                                                            'fecha_retiro':
                                                                fechaControllerEdit
                                                                    .text,
                                                            'hora_retiro':
                                                                horaControllerEdit
                                                                    .text,
                                                            'motivo_retiro':
                                                                motivoControllerEdit
                                                                    .text
                                                          };
                                                          request.headers
                                                              .addAll(headers);

                                                          request.send();

                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                        },
                                                        child: Text('Agregar',
                                                            style:
                                                                cardSubTextStyle),
                                                      )
                                                    ],
                                                    icon: const Icon(
                                                        Icons.publish),
                                                    title: const Text(
                                                        'Confirmar Operacion'),
                                                    content: const Text(
                                                        'Seguro que desea agregar cambios al registro?'),
                                                  );
                                                });
                                          },
                                          child: Text(
                                            'Editar',
                                            style: cardSubTextStyle,
                                          ))),
                                  const Divider(
                                    indent: 5.0,
                                  ),
                                  Expanded(
                                      child: FilledButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    titleTextStyle:
                                                        cardTextStyle,
                                                    contentTextStyle:
                                                        cardSubTextStyle,
                                                    iconColor: colorPrincipal,
                                                    backgroundColor:
                                                        colorSecundario,
                                                    shape: cardShape,
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Cancelar',
                                                            style:
                                                                cardSubTextStyle),
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              style:
                                                                  cardSubTextStyle,
                                                              'Descartar'))
                                                    ],
                                                    icon: const Icon(
                                                        Icons.unpublished),
                                                    title: Text(
                                                      'Descartar Operacion',
                                                      style: cardTextStyle,
                                                    ),
                                                    content: Text(
                                                      'Seguro que desea descartar la operacion?',
                                                      style: cardTextStyle,
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Text(
                                            'Descartar',
                                            style: cardSubTextStyle,
                                          )))
                                ],
                              ),
                            ),
                          ],
                        )),
                      );
                    }));
              }
            }
          },
          backgroundColor: colorSecundario,
          child: Icon(Icons.edit_note, color: colorPrincipal)),
      FloatingActionButton(
          elevation: 0,
          heroTag: 'btn_delete',
          backgroundColor: colorSecundario,
          onPressed: () {
            var selected = _dataGridController.selectedRows;
            if (selected.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titleTextStyle: cardTextStyle,
                      contentTextStyle: cardSubTextStyle,
                      iconColor: colorPrincipal,
                      backgroundColor: colorSecundario,
                      shape: cardShape,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('CANCELAR', style: cardSubTextStyle),
                        ),
                        TextButton(
                            style: const ButtonStyle(),
                            onPressed: () async {
                              var headers = {
                                'Content-Type':
                                    'application/x-www-form-urlencoded'
                              };
                              var request = http.Request(
                                  'DELETE',
                                  Uri.parse(
                                      'http://132.255.166.73:8474/retiros/borrar'));
                              String idList = '';
                              for (var element in selected) {
                                idList += '${element.getCells().first.value},';
                              }

                              request.bodyFields = {'id': '$idList 0'};
                              request.headers.addAll(headers);

                              http.StreamedResponse response =
                                  await request.send();

                              if (response.statusCode == 200) {
                                setState(() {
                                  Navigator.pop(context);
                                });
                                succesDelete();
                              }
                            },
                            child: Text(
                              "CONFIRMAR",
                              style: cardSubTextStyle,
                            ))
                      ],
                      title: const Text("CONFIRMAR OPERACION"),
                      content: selected.length == 1
                          ? const Text(
                              'Se borrará un registro, esto es permanente. Desea continuar?')
                          : Text(
                              'Se borraran ${selected.length} registros, esto es permanente. Desea continuar?'),
                    );
                  });
            }
          },
          child: Icon(
            Icons.delete_outline,
            color: colorPrincipal,
          ))
    ];
  }

  void succesDelete() {
    var colorPrincipal = Colors.white;
    var colorSecundario = Colors.blue.shade500;
    var colorResaltante = Colors.indigo.shade900;
    var shadowPrincipal =
        const Shadow(color: Colors.black38, offset: Offset(1, 1));

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
            title: const Text('Borrar registro'),
            content: const Text(
              'Operacion exitosa',
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
