import 'dart:convert';
import 'package:bio_farm/models/model_transaction_ingreso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ScreenIngresosRegistro extends StatefulWidget {
  const ScreenIngresosRegistro({super.key});

  @override
  State<ScreenIngresosRegistro> createState() => _ScreenIngresosRegistroState();
}

class _ScreenIngresosRegistroState extends State<ScreenIngresosRegistro> {
  final DataGridController _dataGridController = DataGridController();
  var link = 'http://192.168.0.7:8474/ingresos';
  var queryController = TextEditingController();
  bool visible = false;
  Icon searchIcon = const Icon(Icons.search);
  var bfColor = Colors.blue.shade600.withOpacity(0.7);
  var bfColorBtn = Colors.indigo.shade900.withOpacity(0.7);
  var bfTextStyle = const TextStyle(
    shadows: [
      Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 12)
    ],
    color: Colors.white,
    fontSize: 16,
  );

  List<ModelTransactionIngreso> _transactions = [];
  late TransactionDataSource _transactionDataSource;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var conceptController = TextEditingController();
    var valueController = TextEditingController();
    var desController = TextEditingController();
    var curDate = DateTime.now();
    var dateController =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(curDate));
    var timeController =
        TextEditingController(text: DateFormat.Hm().format(curDate));

    var conceptControllerEdit = TextEditingController();
    var valueControllerEdit = TextEditingController();
    var desControllerEdit = TextEditingController();
    var dateControllerEdit = TextEditingController();
    var timeControllerEdit = TextEditingController();

    return SafeArea(
        child: Scaffold(
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        spacing: 6.5,
        children: getActions(
            conceptController,
            valueController,
            desController,
            dateController,
            timeController,
            conceptControllerEdit,
            valueControllerEdit,
            desControllerEdit,
            dateControllerEdit,
            timeControllerEdit),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registro de Ingresos'),
        backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              strokeAlign: StrokeAlign.outside, width: 1, color: Colors.white),
        ),
      ),
      body: FutureBuilder(
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
                                        'Detalles: ${row.getCells()[1].value}'),
                                  ),
                                  Text('Valor: ${row.getCells()[2].value}'),
                                  Text('Fecha: ${row.getCells()[3].value}'),
                                  Text('Hora: ${row.getCells()[4].value}'),
                                  Text('Descuento: ${row.getCells()[5].value}')
                                ],
                              ),
                              titleTextStyle: bfTextStyle,
                              contentTextStyle: bfTextStyle,
                              iconColor: Colors.white,
                              backgroundColor: bfColor,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(12.0)),
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
                    backgroundColor: Colors.white,
                    strokeWidth: 8,
                  ),
                );
        },
        future: getTransactionData(link),
      ),
    ));
  }

  Future getTransactionData(String url) async {
    var response = await http.get(Uri.parse(url));
    List list = json.decode(response.body);
    _transactions = listToModel(list);
    _transactionDataSource = TransactionDataSource(_transactions);
    return _transactionDataSource;
  }

  List<ModelTransactionIngreso> listToModel(List mapa) {
    List<ModelTransactionIngreso> lista = [];
    for (var v in mapa) {
      lista.add(ModelTransactionIngreso.fromJson(v));
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
          allowSorting: false,
          allowFiltering: true,
          columnName: 'Detalles',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Detalles'),
          )),
      GridColumn(
          allowFiltering: true,
          columnName: 'Valor',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Valor'),
          )),
      GridColumn(
          allowFiltering: false,
          columnName: 'Fecha',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Fecha'),
          )),
      GridColumn(
          allowFiltering: false,
          columnName: 'Hora',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Hora'),
          )),
      GridColumn(
          allowFiltering: true,
          columnName: 'Descuento',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Descuento'),
          ))
    ];
  }

  List<Widget> getActions(
      conceptController,
      valueController,
      desController,
      dateController,
      timeController,
      conceptControllerEdit,
      valueControllerEdit,
      desControllerEdit,
      dateControllerEdit,
      timeControllerEdit) {
    return [
      FloatingActionButton(
          heroTag: 'btn_add',
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
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
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 3)
                                ],
                                border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                    strokeAlign: StrokeAlign.inside),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                color: Colors.blue.shade600),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'Agregar al registro',
                                  style: bfTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            controller: conceptController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                label: Text('Concepto del Ingreso')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'\d')),
                            ],
                            controller: valueController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text('Valor del Ingreso (Guaranies)')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'\d')),
                            ],
                            controller: desController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label:
                                    Text('Descuento del Ingreso (Guaranies)')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            onTap: () async {
                              dateController.text = await showDatePicker(
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
                                  return dateController.text;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Fecha del ingreso'),
                            readOnly: true,
                            controller: dateController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            onTap: () async {
                              timeController.text = await showTimePicker(
                                      helpText: 'Fijar hora del Ingreso',
                                      cancelText: 'Cancelar',
                                      confirmText: 'Aceptar',
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.dialOnly)
                                  .then((value) {
                                if (value != null) {
                                  return MaterialLocalizations.of(context)
                                      .formatTimeOfDay(value,
                                          alwaysUse24HourFormat: true);
                                } else {
                                  return timeController.text;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Hora del ingreso'),
                            readOnly: true,
                            controller: timeController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                      style: ButtonStyle(
                                          side: const MaterialStatePropertyAll(
                                              BorderSide(
                                                  color: Colors.white,
                                                  width: 1)),
                                          elevation:
                                              MaterialStateProperty.all(5),
                                          shadowColor:
                                              const MaterialStatePropertyAll(
                                                  Colors.black),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  bfColor)),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                titleTextStyle: bfTextStyle,
                                                contentTextStyle: bfTextStyle,
                                                backgroundColor: bfColor,
                                                shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 1,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0)),
                                                iconColor: Colors.white,
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                          style: bfTextStyle,
                                                          'Cancelar')),
                                                  TextButton(
                                                      onPressed: () {
                                                        if (conceptController
                                                                .text ==
                                                            '') {
                                                          conceptController
                                                                  .text =
                                                              '(Sin concepto)';
                                                        }
                                                        if (valueController
                                                                .text ==
                                                            '') {
                                                          valueController.text =
                                                              '0.0';
                                                        }
                                                        if (desController
                                                                .text ==
                                                            '') {
                                                          desController.text =
                                                              '0.0';
                                                        }
                                                        var headers = {
                                                          'Content-Type':
                                                              'application/x-www-form-urlencoded'
                                                        };
                                                        var request = http.Request(
                                                            'POST',
                                                            Uri.parse(
                                                                'http://192.168.0.7:8474/ingresos/agregar'));
                                                        request.bodyFields = {
                                                          'concepto':
                                                              conceptController
                                                                  .text,
                                                          'valor':
                                                              valueController
                                                                  .text,
                                                          'descuento':
                                                              desController
                                                                  .text,
                                                          'fecha':
                                                              dateController
                                                                  .text,
                                                          'hora': timeController
                                                              .text
                                                        };
                                                        request.headers
                                                            .addAll(headers);

                                                        request.send();

                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      child: Text(
                                                        'Agregar',
                                                        style: bfTextStyle,
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
                                        style: bfTextStyle,
                                      ))),
                              const Divider(
                                indent: 5.0,
                              ),
                              Expanded(
                                  child: TextButton(
                                      style: ButtonStyle(
                                          side: const MaterialStatePropertyAll(
                                              BorderSide(
                                                  color: Colors.white,
                                                  width: 1)),
                                          elevation:
                                              MaterialStateProperty.all(5),
                                          shadowColor:
                                              const MaterialStatePropertyAll(
                                                  Colors.black),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  bfColor)),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                titleTextStyle: bfTextStyle,
                                                contentTextStyle: bfTextStyle,
                                                iconColor: Colors.white,
                                                backgroundColor: bfColor,
                                                shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 1,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0)),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Cancelar',
                                                        style: bfTextStyle,
                                                      )),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Descartar',
                                                        style: bfTextStyle),
                                                  )
                                                ],
                                                icon: const Icon(
                                                    Icons.unpublished),
                                                title: Text(
                                                  'Descartar Operacion',
                                                  style: bfTextStyle,
                                                ),
                                                content: Text(
                                                  'Seguro que desea descartar la operacion?',
                                                  style: bfTextStyle,
                                                ),
                                              );
                                            });
                                      },
                                      child: Text(
                                        'Descartar',
                                        style: bfTextStyle,
                                      )))
                            ],
                          ),
                        ),
                      ],
                    )),
                  );
                }));
          },
          backgroundColor: bfColor,
          child: const Icon(Icons.playlist_add, color: Colors.white)),
      FloatingActionButton(
          heroTag: 'btn_edit',
          onPressed: () {
            if (_dataGridController.selectedRows.isNotEmpty) {
              if (_dataGridController.selectedRows.length > 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        titleTextStyle: bfTextStyle,
                        contentTextStyle: bfTextStyle,
                        shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(12.0)),
                        iconColor: Colors.white,
                        backgroundColor: bfColor,
                        actions: [
                          TextButton(
                              child: Text(
                                'Aceptar',
                                style: bfTextStyle,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        title: Text(
                          'Seleccione un solo registro',
                          style: bfTextStyle,
                        ),
                        content: Text(
                          'Esta operacion solo puede realizarse con un registro a la vez, porfavor seleccione un solo registro',
                          style: bfTextStyle,
                        ),
                      );
                    });
              } else {
                var selection =
                    _dataGridController.selectedRows.first.getCells();
                int regId = selection[0].value;
                conceptControllerEdit.text = selection[1].value;
                valueControllerEdit.text = selection[2].value.toString();
                dateControllerEdit.text = selection[3].value.toString();
                timeControllerEdit.text = selection[4].value.toString();
                desControllerEdit.text = selection[5].value.toString();

                showModalBottomSheet(
                    isScrollControlled: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
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
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1),
                                          blurRadius: 3)
                                    ],
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                        strokeAlign: StrokeAlign.inside),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    color: Colors.blue.shade600),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      'Modificar registro ($regId)',
                                      style: bfTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TextField(
                                controller: conceptControllerEdit,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    label: Text('Concepto del Ingreso')),
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
                                controller: valueControllerEdit,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    label:
                                        Text('Valor del Ingreso (Guaranies)')),
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
                                controller: desControllerEdit,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    label: Text(
                                        'Descuento del Ingreso (Guaranies)')),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TextField(
                                onTap: () async {
                                  dateController.text = await showDatePicker(
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
                                      return dateControllerEdit.text;
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Fecha del ingreso'),
                                readOnly: true,
                                controller: dateControllerEdit,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextField(
                                onTap: () async {
                                  timeController.text = await showTimePicker(
                                          helpText: 'Fijar hora del Ingreso',
                                          cancelText: 'Cancelar',
                                          confirmText: 'Aceptar',
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          initialEntryMode:
                                              TimePickerEntryMode.dialOnly)
                                      .then((value) {
                                    if (value != null) {
                                      return MaterialLocalizations.of(context)
                                          .formatTimeOfDay(value,
                                              alwaysUse24HourFormat: true);
                                    } else {
                                      return timeControllerEdit.text;
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Hora del ingreso'),
                                readOnly: true,
                                controller: timeControllerEdit,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextButton(
                                          style: ButtonStyle(
                                              side:
                                                  const MaterialStatePropertyAll(
                                                      BorderSide(
                                                          color: Colors.white,
                                                          width: 1)),
                                              elevation:
                                                  MaterialStateProperty.all(5),
                                              shadowColor:
                                                  const MaterialStatePropertyAll(
                                                      Colors.black),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      bfColor)),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    titleTextStyle: bfTextStyle,
                                                    contentTextStyle:
                                                        bfTextStyle,
                                                    backgroundColor: bfColor,
                                                    shape: RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    12.0)),
                                                    iconColor: Colors.white,
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Cancelar',
                                                            style: bfTextStyle),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          if (conceptControllerEdit
                                                                  .text ==
                                                              '') {
                                                            conceptControllerEdit
                                                                    .text =
                                                                '(Sin concepto)';
                                                          }
                                                          if (valueControllerEdit
                                                                  .text ==
                                                              '') {
                                                            valueControllerEdit
                                                                .text = '0.0';
                                                          }
                                                          if (desControllerEdit
                                                                  .text ==
                                                              '') {
                                                            desControllerEdit
                                                                .text = '0.0';
                                                          }
                                                          var headers = {
                                                            'Content-Type':
                                                                'application/x-www-form-urlencoded'
                                                          };
                                                          var request =
                                                              http.Request(
                                                                  'POST',
                                                                  Uri.parse(
                                                                      'http://192.168.0.7:8474/ingresos/editar'));
                                                          request.bodyFields = {
                                                            'id_ingreso': regId
                                                                .toString(),
                                                            'concepto':
                                                                conceptControllerEdit
                                                                    .text,
                                                            'valor':
                                                                valueControllerEdit
                                                                    .text,
                                                            'descuento':
                                                                desControllerEdit
                                                                    .text,
                                                            'fecha':
                                                                dateControllerEdit
                                                                    .text,
                                                            'hora':
                                                                timeControllerEdit
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
                                                            style: bfTextStyle),
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
                                            style: bfTextStyle,
                                          ))),
                                  const Divider(
                                    indent: 5.0,
                                  ),
                                  Expanded(
                                      child: TextButton(
                                          style: ButtonStyle(
                                              side:
                                                  const MaterialStatePropertyAll(
                                                      BorderSide(
                                                          color: Colors.white,
                                                          width: 1)),
                                              elevation:
                                                  MaterialStateProperty.all(5),
                                              shadowColor:
                                                  const MaterialStatePropertyAll(
                                                      Colors.black),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      bfColor)),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    titleTextStyle: bfTextStyle,
                                                    contentTextStyle:
                                                        bfTextStyle,
                                                    iconColor: Colors.white,
                                                    backgroundColor: bfColor,
                                                    shape: RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    12.0)),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Cancelar',
                                                            style: bfTextStyle),
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
                                                                  bfTextStyle,
                                                              'Descartar'))
                                                    ],
                                                    icon: const Icon(
                                                        Icons.unpublished),
                                                    title: Text(
                                                      'Descartar Operacion',
                                                      style: bfTextStyle,
                                                    ),
                                                    content: Text(
                                                      'Seguro que desea descartar la operacion?',
                                                      style: bfTextStyle,
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Text(
                                            'Descartar',
                                            style: bfTextStyle,
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
          backgroundColor: bfColor,
          child: const Icon(Icons.edit_note, color: Colors.white)),
      FloatingActionButton(
          heroTag: 'btn_delete',
          backgroundColor: bfColor,
          onPressed: () {
            var selected = _dataGridController.selectedRows;
            if (selected.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titleTextStyle: bfTextStyle,
                      contentTextStyle: bfTextStyle,
                      iconColor: Colors.white,
                      backgroundColor: bfColor,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(12.0)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('CANCELAR', style: bfTextStyle),
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
                                      'http://192.168.0.7:8474/ingresos/borrar'));
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
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        icon: const Icon(Icons.check),
                                        titleTextStyle: bfTextStyle,
                                        contentTextStyle: bfTextStyle,
                                        iconColor: Colors.white,
                                        backgroundColor: bfColor,
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 1, color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        title: const Text('Borrar registro'),
                                        content: const Text(
                                          'Operacion exitosa',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    });
                              }
                            },
                            child: Text(
                              "CONFIRMAR",
                              style: bfTextStyle,
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
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ))
    ];
  }
}
