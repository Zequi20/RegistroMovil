import 'dart:convert';
import 'package:bio_farm/models/model_funcionario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ScreenFuncionariosRegistro extends StatefulWidget {
  const ScreenFuncionariosRegistro({super.key});

  @override
  State<ScreenFuncionariosRegistro> createState() =>
      _ScreenFuncionariosRegistroState();
}

class _ScreenFuncionariosRegistroState
    extends State<ScreenFuncionariosRegistro> {
  final DataGridController _dataGridController = DataGridController();
  var link = 'http://192.168.0.7:8474/funcionarios';
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

  List<ModelTransactionFuncionario> _transactions = [];
  late TransactionDataSource _transactionDataSource;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var curDate = DateTime.now();
    var ciController = TextEditingController();
    var nombreController = TextEditingController();
    var sueldoController = TextEditingController();
    var fechaCobroController = TextEditingController(
        text: DateFormat('yyyy-MM-dd')
            .format(curDate.add(const Duration(days: 30))));
    var telefController = TextEditingController();
    var correoController = TextEditingController();
    var horarioController = TextEditingController(text: '00:00 - 00:00');
    var puestoController = TextEditingController();
    var fechaInicioController =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(curDate));

    var ciControllerEdit = TextEditingController();
    var nombreControllerEdit = TextEditingController();
    var sueldoControllerEdit = TextEditingController();
    var fechaCobroControllerEdit =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(curDate));
    var telefControllerEdit = TextEditingController();
    var correoControllerEdit = TextEditingController();
    var horarioControllerEdit = TextEditingController(text: '00:00 - 00:00');
    var puestoControllerEdit = TextEditingController();
    var fechaInicioControllerEdit = TextEditingController();

    return SafeArea(
        child: Scaffold(
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        spacing: 6.5,
        children: getActions(
            ciController,
            nombreController,
            sueldoController,
            fechaCobroController,
            telefController,
            correoController,
            horarioController,
            puestoController,
            fechaInicioController,
            ciControllerEdit,
            nombreControllerEdit,
            sueldoControllerEdit,
            fechaCobroControllerEdit,
            telefControllerEdit,
            correoControllerEdit,
            horarioControllerEdit,
            puestoControllerEdit,
            fechaInicioControllerEdit),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registro de Funcionarios'),
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
                                    child:
                                        Text('CI: ${row.getCells()[1].value}'),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                        'Nombre: ${row.getCells()[2].value}'),
                                  ),
                                  Text('Sueldo: ${row.getCells()[3].value}'),
                                  Text(
                                      'Fecha de cobro: ${row.getCells()[4].value}'),
                                  Text('Telefono: ${row.getCells()[5].value}'),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                        'Correo: ${row.getCells()[6].value}'),
                                  ),
                                  Text('Horario: ${row.getCells()[7].value}'),
                                  Text('Puesto: ${row.getCells()[8].value}'),
                                  Text(
                                      'Fecha de inicio: ${row.getCells()[9].value}'),
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

  List<ModelTransactionFuncionario> listToModel(List mapa) {
    List<ModelTransactionFuncionario> lista = [];
    for (var v in mapa) {
      lista.add(ModelTransactionFuncionario.fromJson(v));
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
          columnName: 'Ci',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('CI'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Nombre',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Nombre y apellido'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Sueldo',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Sueldo'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Fecha Pago',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Fecha de cobro'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Telefono',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Nro de telefono'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Correo',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Direccion de correo'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Horario',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Horario'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Cargo',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Puesto'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Fecha Inicio',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Fecha de inicio'),
          )),
    ];
  }

  List<Widget> getActions(
      ciController,
      nombreController,
      sueldoController,
      fechaCobroController,
      telefController,
      correoController,
      horarioController,
      puestoController,
      fechaInicioController,
      ciControllerEdit,
      nombreControllerEdit,
      sueldoControllerEdit,
      fechaCobroControllerEdit,
      telefControllerEdit,
      correoControllerEdit,
      horarioControllerEdit,
      puestoControllerEdit,
      fechaInicioControllerEdit) {
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
              builder: (context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'\d'))
                              ],
                              controller: ciController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Cedula de Identidad')),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: nombreController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Nombre del funcionario')),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'\d'))
                              ],
                              controller: sueldoController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Sueldo del funcionario')),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'\d'))
                              ],
                              controller: fechaCobroController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Fecha de Cobro')),
                              onTap: () async {
                                fechaCobroController
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
                                    return fechaCobroControllerEdit.text;
                                  }
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'\d'))
                              ],
                              controller: telefController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Telefono del funcionario')),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: correoController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text(
                                      'Direccion de correo del funcionario')),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              readOnly: true,
                              controller: horarioController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Horario del funcionario')),
                              onTap: () async {
                                String first = '';
                                String second = '';
                                try {
                                  TimeRange rangue = await showTimeRangePicker(
                                      context: context,
                                      fromText: 'Desde las:',
                                      toText: 'Hasta las:')!;

                                  DateTime firstDate = DateTime(
                                      0,
                                      0,
                                      0,
                                      rangue.startTime.hour,
                                      rangue.startTime.minute);
                                  DateTime secondtDate = DateTime(
                                      0,
                                      0,
                                      0,
                                      rangue.endTime.hour,
                                      rangue.endTime.minute);

                                  first = DateFormat('hh:mm').format(firstDate);
                                  second =
                                      DateFormat('hh:mm').format(secondtDate);
                                  horarioController.text = '$first - $second';
                                } on Error catch (_) {
                                  horarioController.text = '00:00 - 00:00';
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: puestoController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Puesto del funcionario')),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              onTap: () async {
                                fechaInicioController
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
                                    return fechaInicioController.text;
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Fecha del ingreso'),
                              readOnly: true,
                              controller: fechaInicioController,
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            style: bfTextStyle,
                                                            'Cancelar')),
                                                    TextButton(
                                                        onPressed: () {
                                                          if (ciController
                                                                  .text ==
                                                              '') {
                                                            ciController.text =
                                                                '0';
                                                          }
                                                          if (nombreController
                                                                  .text
                                                                  .toString() ==
                                                              '') {
                                                            nombreController
                                                                    .text =
                                                                '(Sin nombre)';
                                                          }
                                                          if (sueldoController
                                                                  .text
                                                                  .toString() ==
                                                              '') {
                                                            sueldoController
                                                                .text = '0.0';
                                                          }
                                                          if (telefController
                                                                  .text
                                                                  .toString() ==
                                                              '') {
                                                            telefController
                                                                .text = '0';
                                                          }
                                                          if (correoController
                                                                  .text
                                                                  .toString() ==
                                                              '') {
                                                            correoController
                                                                .text = '0';
                                                          }
                                                          if (puestoController
                                                                  .text
                                                                  .toString() ==
                                                              '') {
                                                            puestoController
                                                                    .text =
                                                                '(Sin puesto)';
                                                          }
                                                          var headers = {
                                                            'Content-Type':
                                                                'application/x-www-form-urlencoded'
                                                          };
                                                          var request =
                                                              http.Request(
                                                                  'POST',
                                                                  Uri.parse(
                                                                      'http://192.168.0.7:8474/funcionarios/agregar'));
                                                          request.bodyFields = {
                                                            'ci_funcionario':
                                                                ciController
                                                                    .text,
                                                            'nombre_funcionario':
                                                                nombreController
                                                                    .text,
                                                            'sueldo_funcionario':
                                                                sueldoController
                                                                    .text,
                                                            'fecha_pago_funcionario':
                                                                fechaCobroController
                                                                    .text,
                                                            'telefono_funcionario':
                                                                telefController
                                                                    .text,
                                                            'correo_funcionario':
                                                                correoController
                                                                    .text,
                                                            'horario_funcionario':
                                                                horarioController
                                                                    .text,
                                                            'cargo_funcionario':
                                                                puestoController
                                                                    .text,
                                                            'fecha_inicio_funcionario':
                                                                fechaInicioController
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
                                                        child: Text(
                                                          'Agregar',
                                                          style: bfTextStyle,
                                                        ))
                                                  ],
                                                  icon:
                                                      const Icon(Icons.publish),
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
                                                          Navigator.pop(
                                                              context);
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
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
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
                ciControllerEdit.text = selection[1].value.toString();
                nombreControllerEdit.text = selection[2].value.toString();
                sueldoControllerEdit.text = selection[3].value.toString();
                fechaCobroControllerEdit.text = selection[4].value.toString();
                telefControllerEdit.text = selection[5].value.toString();
                correoControllerEdit.text = selection[6].value.toString();
                horarioControllerEdit.text = selection[7].value.toString();
                puestoControllerEdit.text = selection[8].value.toString();
                fechaInicioControllerEdit.text = selection[9].value.toString();
                showModalBottomSheet(
                  isScrollControlled: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0.5,
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: MediaQuery.of(context).viewInsets,
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
                                        'Editar el registro $regId',
                                        style: bfTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'\d'))
                                  ],
                                  controller: ciControllerEdit,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      label: Text('Cedula de Identidad')),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  controller: nombreControllerEdit,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      label: Text('Nombre del funcionario')),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'\d'))
                                  ],
                                  controller: sueldoControllerEdit,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      label: Text('Sueldo del funcionario')),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'\d'))
                                  ],
                                  controller: fechaCobroControllerEdit,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      label: Text('Fecha de Cobro')),
                                  onTap: () async {
                                    fechaCobroControllerEdit.text =
                                        await showDatePicker(
                                                cancelText: 'Cancelar',
                                                confirmText: 'Aceptar',
                                                initialEntryMode:
                                                    DatePickerEntryMode
                                                        .calendarOnly,
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000, 1, 1),
                                                lastDate: DateTime.now())
                                            .then((value) {
                                      if (value != null) {
                                        return DateFormat('yyyy-MM-dd')
                                            .format(value);
                                      } else {
                                        return fechaCobroControllerEdit.text;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'\d'))
                                  ],
                                  controller: telefControllerEdit,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      label: Text('Telefono del funcionario')),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  controller: correoControllerEdit,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      label: Text(
                                          'Direccion de correo del funcionario')),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  readOnly: true,
                                  controller: horarioControllerEdit,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      label: Text('Horario del funcionario')),
                                  onTap: () async {
                                    String first = '';
                                    String second = '';
                                    try {
                                      TimeRange rangue =
                                          await showTimeRangePicker(
                                              context: context,
                                              fromText: 'Desde las:',
                                              toText: 'Hasta las:')!;

                                      DateTime firstDate = DateTime(
                                          0,
                                          0,
                                          0,
                                          rangue.startTime.hour,
                                          rangue.startTime.minute);
                                      DateTime secondtDate = DateTime(
                                          0,
                                          0,
                                          0,
                                          rangue.endTime.hour,
                                          rangue.endTime.minute);

                                      first =
                                          DateFormat('hh:mm').format(firstDate);
                                      second = DateFormat('hh:mm')
                                          .format(secondtDate);
                                      horarioControllerEdit.text =
                                          '$first - $second';
                                    } on Error catch (_) {
                                      horarioControllerEdit.text =
                                          '00:00 - 00:00';
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  controller: puestoControllerEdit,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      label: Text('Puesto del funcionario')),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextField(
                                  onTap: () async {
                                    fechaInicioControllerEdit.text =
                                        await showDatePicker(
                                                cancelText: 'Cancelar',
                                                confirmText: 'Aceptar',
                                                initialEntryMode:
                                                    DatePickerEntryMode
                                                        .calendarOnly,
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000, 1, 1),
                                                lastDate: DateTime.now())
                                            .then((value) {
                                      if (value != null) {
                                        return DateFormat('yyyy-MM-dd')
                                            .format(value);
                                      } else {
                                        return fechaInicioControllerEdit.text;
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Fecha del ingreso'),
                                  readOnly: true,
                                  controller: fechaInicioControllerEdit,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
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
                                                    MaterialStateProperty.all(
                                                        5),
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
                                                      titleTextStyle:
                                                          bfTextStyle,
                                                      contentTextStyle:
                                                          bfTextStyle,
                                                      backgroundColor: bfColor,
                                                      shape: RoundedRectangleBorder(
                                                          side:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white),
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
                                                            child: Text(
                                                                style:
                                                                    bfTextStyle,
                                                                'Cancelar')),
                                                        TextButton(
                                                            onPressed: () {
                                                              if (ciControllerEdit
                                                                      .text ==
                                                                  '') {
                                                                ciControllerEdit
                                                                        .text =
                                                                    '(Sin Ci)';
                                                              }
                                                              if (nombreControllerEdit
                                                                      .text
                                                                      .toString() ==
                                                                  '') {
                                                                nombreControllerEdit
                                                                        .text =
                                                                    '(Sin nombre)';
                                                              }
                                                              if (sueldoControllerEdit
                                                                      .text
                                                                      .toString() ==
                                                                  '') {
                                                                sueldoControllerEdit
                                                                        .text =
                                                                    '0.0';
                                                              }
                                                              if (telefControllerEdit
                                                                      .text
                                                                      .toString() ==
                                                                  '') {
                                                                telefControllerEdit
                                                                    .text = '0';
                                                              }
                                                              if (correoControllerEdit
                                                                      .text
                                                                      .toString() ==
                                                                  '') {
                                                                correoControllerEdit
                                                                    .text = '0';
                                                              }
                                                              if (puestoControllerEdit
                                                                      .text
                                                                      .toString() ==
                                                                  '') {
                                                                puestoControllerEdit
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
                                                                          'http://192.168.0.7:8474/funcionarios/editar'));
                                                              request
                                                                  .bodyFields = {
                                                                'id_funcionario':
                                                                    '$regId',
                                                                'ci_funcionario':
                                                                    ciControllerEdit
                                                                        .text,
                                                                'nombre_funcionario':
                                                                    nombreControllerEdit
                                                                        .text,
                                                                'sueldo_funcionario':
                                                                    sueldoControllerEdit
                                                                        .text,
                                                                'fecha_pago_funcionario':
                                                                    fechaCobroControllerEdit
                                                                        .text,
                                                                'telefono_funcionario':
                                                                    telefControllerEdit
                                                                        .text,
                                                                'correo_funcionario':
                                                                    correoControllerEdit
                                                                        .text,
                                                                'horario_funcionario':
                                                                    horarioControllerEdit
                                                                        .text,
                                                                'cargo_funcionario':
                                                                    puestoControllerEdit
                                                                        .text,
                                                                'fecha_inicio_funcionario':
                                                                    fechaInicioControllerEdit
                                                                        .text
                                                              };
                                                              request.headers
                                                                  .addAll(
                                                                      headers);

                                                              request.send();

                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {});
                                                            },
                                                            child: Text(
                                                              'Agregar',
                                                              style:
                                                                  bfTextStyle,
                                                            ))
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
                                                    MaterialStateProperty.all(
                                                        5),
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
                                                      titleTextStyle:
                                                          bfTextStyle,
                                                      contentTextStyle:
                                                          bfTextStyle,
                                                      iconColor: Colors.white,
                                                      backgroundColor: bfColor,
                                                      shape: RoundedRectangleBorder(
                                                          side:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white),
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
                                                            child: Text(
                                                              'Cancelar',
                                                              style:
                                                                  bfTextStyle,
                                                            )),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              'Descartar',
                                                              style:
                                                                  bfTextStyle),
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
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
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
                                      'http://192.168.0.7:8474/funcionarios/borrar'));
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
