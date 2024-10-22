import 'dart:convert';
import 'package:bio_farm/models/model_funcionario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../screenParams/arguments.dart';

class ScreenFuncionariosRegistro extends StatefulWidget {
  const ScreenFuncionariosRegistro({super.key});

  @override
  State<ScreenFuncionariosRegistro> createState() =>
      _ScreenFuncionariosRegistroState();
}

class _ScreenFuncionariosRegistroState
    extends State<ScreenFuncionariosRegistro> {
  final DataGridController _dataGridController = DataGridController();
  var link = 'http://132.255.166.73:8474/funcionarios';
  var queryController = TextEditingController();
  bool visible = false;
  Icon searchIcon = const Icon(Icons.search);

  List<ModelFuncionario> _transactions = [];
  late FuncionarioDataSource _transactionDataSource;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GestionArguments;
    var curDate = DateTime.now();
    var ciController = TextEditingController();
    var nombreController = TextEditingController();
    var telefonoController = TextEditingController();
    var correoController = TextEditingController();
    var fechaInicioController =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(curDate));
    var fechaCobroController =
        TextEditingController(text: DateFormat('dd').format(curDate));
    var sueldoController = TextEditingController();
    var horaEntradaController = TextEditingController();
    var horaSalidaController = TextEditingController();

    var ciControllerEdit = TextEditingController();
    var nombreControllerEdit = TextEditingController();
    var telefonoControllerEdit = TextEditingController();
    var correoControllerEdit = TextEditingController();
    var fechaInicioControllerEdit =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(curDate));
    var fechaCobroControllerEdit =
        TextEditingController(text: DateFormat('dd').format(curDate));
    var sueldoControllerEdit = TextEditingController();
    var horaEntradaControllerEdit = TextEditingController();
    var horaSalidaControllerEdit = TextEditingController();

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
            ciController,
            nombreController,
            telefonoController,
            correoController,
            sueldoController,
            fechaInicioController,
            horaEntradaController,
            horaSalidaController,
            ciControllerEdit,
            nombreControllerEdit,
            telefonoControllerEdit,
            correoControllerEdit,
            fechaInicioControllerEdit,
            fechaCobroControllerEdit,
            fechaCobroController,
            sueldoControllerEdit,
            horaEntradaControllerEdit,
            horaSalidaControllerEdit,
          ),
        ),
      ),
      backgroundColor: colorPrincipal,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [colorPrincipal, colorSecundario])),
        ),
        elevation: 15,
        iconTheme: IconThemeData(color: colorResaltante),
        centerTitle: true,
        title: Text(
          'Funcionarios ${args.nombreSede}',
          style: titleTextStyle,
        ),
        backgroundColor: colorPrincipal,
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
                                  Text('Sueldo: ${row.getCells()[7].value}'),
                                  Text(
                                      'Fecha de inicio: ${row.getCells()[5].value}'),
                                  Text(
                                      'Fecha de cobro: ${row.getCells()[6].value}'),
                                  Text('Telefono: ${row.getCells()[3].value}'),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                        'Correo: ${row.getCells()[4].value}'),
                                  ),
                                  Text(
                                      'Horario: ${row.getCells()[8].value}-${row.getCells()[9].value}'),
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
                    backgroundColor: Colors.white,
                    strokeWidth: 8,
                  ),
                );
        },
        future: getTransaccionData(link, args),
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

    _transactionDataSource = FuncionarioDataSource(_transactions);

    return _transactionDataSource;
  }

  List<ModelFuncionario> listToModel(List mapa) {
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
          allowSorting: true,
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
          columnName: 'Telefono',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Numero de telefono'),
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
          columnName: 'Fecha de Inicio',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Fecha de inicio'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Fecha de Cobro',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Fecha de cobro'),
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
          columnName: 'Entrada',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Hora de entrada'),
          )),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Salida',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Hora de salida'),
          )),
    ];
  }

  List<Widget> getActions(
    GestionArguments args,
    TextEditingController fechaCobroController,
    TextEditingController ciController,
    TextEditingController nombreController,
    TextEditingController telefonoController,
    TextEditingController correoController,
    TextEditingController fechaInicioController,
    TextEditingController sueldoController,
    TextEditingController horaEntradaController,
    TextEditingController horaSalidaController,
    TextEditingController ciControllerEdit,
    TextEditingController nombreControllerEdit,
    TextEditingController telefonoControllerEdit,
    TextEditingController correoControllerEdit,
    TextEditingController fechaInicioControllerEdit,
    TextEditingController fechaCobroControllerEdit,
    TextEditingController sueldoControllerEdit,
    TextEditingController horaEntradaControllerEdit,
    TextEditingController horaSalidaControllerEdit,
  ) {
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'\d'))
                              ],
                              controller: ciController,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                  label: Text('Cedula de Identidad')),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: nombreController,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  label: Text('Nombre del funcionario')),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'\d'))
                                  ],
                                  controller: telefonoController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                      label: Text('Telefono del funcionario')),
                                )),
                                Expanded(
                                    child: TextField(
                                  controller: correoController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      label: Text('Correo del funcionario')),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  onTap: () async {
                                    fechaInicioController.text =
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
                                        return fechaInicioController.text;
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Fecha de inicio'),
                                  readOnly: true,
                                  controller: fechaInicioController,
                                )),
                                Expanded(
                                    child: TextField(
                                  onTap: () async {
                                    fechaCobroController.text =
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
                                        return DateFormat('dd').format(value);
                                      } else {
                                        return fechaCobroController.text;
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Fecha de cobro'),
                                  readOnly: true,
                                  controller: fechaCobroController,
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  onTap: () async {
                                    horaEntradaController.text =
                                        await showTimePicker(
                                      helpText: 'Fijar hora de Entrada',
                                      cancelText: 'Cancelar',
                                      confirmText: 'Aceptar',
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.inputOnly,
                                    ).then((value) {
                                      if (value != null) {
                                        return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
                                      } else {
                                        return horaEntradaController.text;
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Hora de Entrada'),
                                  readOnly: true,
                                  controller: horaEntradaController,
                                )),
                                Expanded(
                                    child: TextField(
                                  onTap: () async {
                                    horaSalidaController.text =
                                        await showTimePicker(
                                      helpText: 'Fijar hora de Salida',
                                      cancelText: 'Cancelar',
                                      confirmText: 'Aceptar',
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.inputOnly,
                                    ).then((value) {
                                      if (value != null) {
                                        return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
                                      } else {
                                        return horaSalidaController.text;
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Hora de Salida'),
                                  readOnly: true,
                                  controller: horaSalidaController,
                                ))
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'\d'))
                                ],
                                controller: sueldoController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                    label: Text('Sueldo del funcionario')),
                              )),
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            style:
                                                                cardSubTextStyle,
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
                                                          if (telefonoController
                                                                  .text
                                                                  .toString() ==
                                                              '') {
                                                            telefonoController
                                                                .text = '0';
                                                          }
                                                          if (correoController
                                                                  .text
                                                                  .toString() ==
                                                              '') {
                                                            correoController
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
                                                                      'http://132.255.166.73:8474/insertar_funcionario'));
                                                          request.bodyFields = {
                                                            'id_sede': args
                                                                .idSede
                                                                .toString(),
                                                            'ci_funcionario':
                                                                ciController
                                                                    .text,
                                                            'nombre_funcionario':
                                                                nombreController
                                                                    .text,
                                                            'telefono_funcionario':
                                                                telefonoController
                                                                    .text,
                                                            'correo_funcionario':
                                                                correoController
                                                                    .text,
                                                            'fecha_inicio_funcionario':
                                                                fechaInicioController
                                                                    .text,
                                                            'sueldo_funcionario':
                                                                sueldoController
                                                                    .text,
                                                            'hora_entrada_funcionario':
                                                                horaEntradaController
                                                                    .text,
                                                            'hora_salida_funcionario':
                                                                horaSalidaController
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
                                                          style:
                                                              cardSubTextStyle,
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Cancelar',
                                                          style:
                                                              cardSubTextStyle,
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
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: colorSecundario,
          child: const Icon(Icons.playlist_add, color: Colors.white)),
      FloatingActionButton(
          elevation: 0,
          heroTag: 'btn_edit',
          onPressed: () async {
            if (_dataGridController.selectedRows.isNotEmpty) {
              if (_dataGridController.selectedRows.length > 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        titleTextStyle: cardTextStyle,
                        contentTextStyle: cardTextStyle,
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
                ciControllerEdit.text = selection[1].value.toString();
                nombreControllerEdit.text = selection[2].value.toString();
                telefonoControllerEdit.text = selection[3].value.toString();
                correoControllerEdit.text = selection[4].value.toString();
                fechaInicioControllerEdit.text = selection[5].value.toString();
                fechaCobroControllerEdit.text = selection[6].value.toString();
                sueldoControllerEdit.text = selection[7].value.toString();
                horaEntradaControllerEdit.text = selection[8].value.toString();
                horaSalidaControllerEdit.text = selection[9].value.toString();
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
                                          strokeAlign:
                                              BorderSide.strokeAlignInside),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: Colors.blue.shade600),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        'Editar el registro $regId',
                                        style: cardTextStyle,
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
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'\d'))
                                      ],
                                      controller: telefonoControllerEdit,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          label:
                                              Text('Telefono del funcionario')),
                                    )),
                                    Expanded(
                                        child: TextField(
                                      controller: correoControllerEdit,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                          label:
                                              Text('Correo del funcionario')),
                                    ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextField(
                                      onTap: () async {
                                        fechaInicioControllerEdit
                                            .text = await showDatePicker(
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
                                            return fechaInicioControllerEdit
                                                .text;
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelText: 'Fecha de inicio'),
                                      readOnly: true,
                                      controller: fechaInicioControllerEdit,
                                    )),
                                    Expanded(
                                        child: TextField(
                                      onTap: () async {
                                        fechaCobroControllerEdit
                                            .text = await showDatePicker(
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
                                            return DateFormat('dd')
                                                .format(value);
                                          } else {
                                            return fechaCobroControllerEdit
                                                .text;
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelText: 'Fecha de cobro'),
                                      readOnly: true,
                                      controller: fechaCobroControllerEdit,
                                    ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextField(
                                      onTap: () async {
                                        horaEntradaControllerEdit.text =
                                            await showTimePicker(
                                          helpText: 'Fijar hora de Entrada',
                                          cancelText: 'Cancelar',
                                          confirmText: 'Aceptar',
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          initialEntryMode:
                                              TimePickerEntryMode.inputOnly,
                                        ).then((value) {
                                          if (value != null) {
                                            return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
                                          } else {
                                            return horaEntradaControllerEdit
                                                .text;
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelText: 'Hora de Entrada'),
                                      readOnly: true,
                                      controller: horaEntradaControllerEdit,
                                    )),
                                    Expanded(
                                        child: TextField(
                                      onTap: () async {
                                        horaSalidaControllerEdit.text =
                                            await showTimePicker(
                                          helpText: 'Fijar hora de Salida',
                                          cancelText: 'Cancelar',
                                          confirmText: 'Aceptar',
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          initialEntryMode:
                                              TimePickerEntryMode.inputOnly,
                                        ).then((value) {
                                          if (value != null) {
                                            return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
                                          } else {
                                            return horaSalidaControllerEdit
                                                .text;
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelText: 'Hora de Salida'),
                                      readOnly: true,
                                      controller: horaSalidaControllerEdit,
                                    )),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'\d'))
                                    ],
                                    controller: sueldoControllerEdit,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        label: Text('Sueldo del funcionario')),
                                  )),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
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
                                                      iconColor: Colors.white,
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                                style:
                                                                    cardSubTextStyle,
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
                                                              if (telefonoControllerEdit
                                                                      .text
                                                                      .toString() ==
                                                                  '') {
                                                                telefonoControllerEdit
                                                                    .text = '0';
                                                              }
                                                              if (correoControllerEdit
                                                                      .text
                                                                      .toString() ==
                                                                  '') {
                                                                correoControllerEdit
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
                                                                          'http://132.255.166.73:8474/editar_funcionario'));
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
                                                                'fecha_inicio_funcionario':
                                                                    fechaInicioControllerEdit
                                                                        .text,
                                                                'telefono_funcionario':
                                                                    telefonoControllerEdit
                                                                        .text,
                                                                'correo_funcionario':
                                                                    correoControllerEdit
                                                                        .text,
                                                                'hora_entrada_funcionario':
                                                                    horaEntradaControllerEdit
                                                                        .text,
                                                                'hora_salida_funcionario':
                                                                    horaSalidaControllerEdit
                                                                        .text,
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
                                                                  cardSubTextStyle,
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
                                                      shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  colorPrincipal),
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
                                                                  cardSubTextStyle,
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
          backgroundColor: colorSecundario,
          child: const Icon(Icons.edit_note, color: Colors.white)),
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
                                      'http://132.255.166.73:8474/eliminar_funcionario'));
                              String idList = '';
                              for (var element in selected) {
                                idList += '${element.getCells().first.value},';
                              }

                              request.bodyFields = {'id_list': '$idList 0'};
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
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
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
