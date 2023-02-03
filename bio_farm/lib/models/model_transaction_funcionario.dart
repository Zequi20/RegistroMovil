import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class ModelTransactionFuncionario {
  factory ModelTransactionFuncionario.fromJson(Map<String, dynamic> json) {
    return ModelTransactionFuncionario(
        json['id_funcionario'],
        json['ci_funcionario'],
        json['nombre_funcionario'],
        double.parse(json['sueldo_funcionario'].toString()),
        DateFormat('yyy-mm-dd')
            .format(DateTime.parse(json['fecha_pago_funcionario'].toString())),
        json['telefono_funcionario'],
        json['correo_funcionario'],
        json['horario_funcionario'],
        json['cargo_funcionario'],
        DateFormat('yyy-mm-dd').format(
            DateTime.parse(json['fecha_inicio_funcionario'].toString())));
  }
  ModelTransactionFuncionario(
      this.funcionarioId,
      this.funcionarioCi,
      this.funcionarioNombre,
      this.funcionarioSueldo,
      this.funcionarioFechaPago,
      this.funcionarioTelefono,
      this.funcionarioCorreo,
      this.funcionarioHorario,
      this.funcionarioCargo,
      this.funcionarioFechaInicio);
  int funcionarioId;
  int funcionarioCi;
  String funcionarioNombre;
  double funcionarioSueldo;
  String funcionarioFechaPago;
  String funcionarioTelefono;
  String funcionarioCorreo;
  String funcionarioHorario;
  String funcionarioCargo;
  String funcionarioFechaInicio;
}

class TransactionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  TransactionDataSource(List<ModelTransactionFuncionario> transactions) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'Id', value: dataGridRow.funcionarioId),
              DataGridCell<int>(
                  columnName: 'Ci', value: dataGridRow.funcionarioCi),
              DataGridCell<String>(
                  columnName: 'Nombre', value: dataGridRow.funcionarioNombre),
              DataGridCell<double>(
                  columnName: 'Sueldo', value: dataGridRow.funcionarioSueldo),
              DataGridCell<String>(
                  columnName: 'Fecha Pago',
                  value: dataGridRow.funcionarioFechaPago),
              DataGridCell<String>(
                  columnName: 'Telefono',
                  value: dataGridRow.funcionarioTelefono),
              DataGridCell<String>(
                  columnName: 'Correo', value: dataGridRow.funcionarioCorreo),
              DataGridCell<String>(
                  columnName: 'Horario', value: dataGridRow.funcionarioHorario),
              DataGridCell<String>(
                  columnName: 'Cargo', value: dataGridRow.funcionarioCargo),
              DataGridCell<String>(
                  columnName: 'Fecha Inicio',
                  value: dataGridRow.funcionarioFechaInicio),
            ]))
        .toList(growable: false);
  }

  void updateDataGridDataSource() {
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            alignment: AlignmentDirectional.center,
            child: Text(
              dataGridCell.value.toString(),
              textAlign: TextAlign.center,
            ),
          );
        }).toList());
  }
}
