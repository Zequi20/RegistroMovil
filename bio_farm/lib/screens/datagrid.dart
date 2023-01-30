import 'dart:convert';
import 'package:bio_farm/models/model_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ScreenDataGrids extends StatefulWidget {
  const ScreenDataGrids({super.key});

  @override
  State<ScreenDataGrids> createState() => _ScreenDataGridsState();
}

class _ScreenDataGridsState extends State<ScreenDataGrids> {
  final DataGridController _dataGridController = DataGridController();
  var link = 'http://localhost:8474/ingresos';
  var queryController = TextEditingController();
  bool visible = false;
  Icon searchIcon = const Icon(Icons.search);

  List<ModelTransaction> _transactions = [];
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
        TextEditingController(text: TimeOfDay.now().format(context));
    return SafeArea(
        child: Scaffold(
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        spacing: 6.5,
        children: getActions(conceptController, valueController, desController,
            dateController, timeController),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Visibility(
            visible: visible,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width) * (2 / 3),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'\d')),
                ],
                textAlignVertical: TextAlignVertical.bottom,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.text,
                cursorColor: Colors.white,
                controller: queryController,
                onChanged: (query) {
                  if (query != '') {
                    _dataGridController.scrollToRow(double.parse(query));
                  }
                },
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (visible) {
                setState(() {
                  visible = false;
                  searchIcon = const Icon(Icons.search);
                  queryController.clear();
                });
              } else {
                setState(() {
                  visible = true;
                  searchIcon = const Icon(Icons.close);
                });
              }
            },
            icon: searchIcon,
            color: Colors.white,
          )
        ],
        title: const Text('Registro de Ingresos'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? SfDataGrid(
                  showCheckboxColumn: true,
                  frozenColumnsCount: 1,
                  isScrollbarAlwaysShown: true,
                  controller: _dataGridController,
                  selectionMode: SelectionMode.multiple,
                  source: _transactionDataSource,
                  columns: getColumns(),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
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
    return _transactions;
  }

  List<ModelTransaction> listToModel(List mapa) {
    List<ModelTransaction> lista = [];
    for (var v in mapa) {
      lista.add(ModelTransaction.fromJson(v));
    }

    return lista;
  }

  List<GridColumn> getColumns() {
    return [
      GridColumn(
          columnName: 'ID',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('ID'),
          )),
      GridColumn(
          columnName: 'Detalles',
          columnWidthMode: ColumnWidthMode.none,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Detalles'),
          )),
      GridColumn(
          columnName: 'Valor',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Valor'),
          )),
      GridColumn(
          columnName: 'Fecha',
          columnWidthMode: ColumnWidthMode.fitByCellValue,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Fecha'),
          )),
      GridColumn(
          columnName: 'Hora',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Hora'),
          )),
      GridColumn(
          columnName: 'Descuento',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Descuento'),
          ))
    ];
  }

  List<Widget> getActions(conceptController, valueController, desController,
      dateController, timeController) {
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                color: Colors.indigo.shade900),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Agregar al registro',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
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
                                  return value.format(context);
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
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.indigo.shade900)),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
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
                                                                'http://localhost:8474/ingresos/agregar'));
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
                                                      child:
                                                          const Text('Agregar'))
                                                ],
                                                icon: const Icon(Icons.publish),
                                                title: const Text(
                                                    'Confirmar Operacion'),
                                                content: const Text(
                                                    'Seguro que desea agregar cambios al registro?'),
                                              );
                                            });
                                      },
                                      child: const Text(
                                        'Agregar',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              const Divider(
                                indent: 5.0,
                              ),
                              Expanded(
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.indigo.shade900)),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          'Cancelar')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          'Descartar'))
                                                ],
                                                icon: const Icon(
                                                    Icons.unpublished),
                                                title: const Text(
                                                    'Descartar Operacion'),
                                                content: const Text(
                                                    'Seguro que desea descartar la operacion?'),
                                              );
                                            });
                                      },
                                      child: const Text(
                                        'Descartar',
                                        style: TextStyle(color: Colors.white),
                                      )))
                            ],
                          ),
                        ),
                      ],
                    )),
                  );
                }));
          },
          backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
          child: const Icon(Icons.playlist_add, color: Colors.white)),
      FloatingActionButton(
          heroTag: 'btn_edit',
          onPressed: null,
          backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
          child: const Icon(Icons.edit_note, color: Colors.white)),
      FloatingActionButton(
          heroTag: 'btn_delete',
          backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
          onPressed: () {
            var selected = _dataGridController.selectedRows;
            if (selected.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('CANCELAR')),
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
                                      'http://localhost:8474/ingresos/borrar'));
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
                                        title: const Text('Borrar registro'),
                                        content:
                                            const Text('Operacion exitosa'),
                                        actions: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(Icons.check,
                                                  color: Colors.green))
                                        ],
                                      );
                                    });
                              }
                            },
                            child: const Text("CONFIRMAR"))
                      ],
                      title: const Text("CONFIRMAR OPERACION"),
                      content: Text(
                          "Segur@ de que quieres borrar ${selected.length} registros?\nEsto es irreversible para la eternidad"),
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
