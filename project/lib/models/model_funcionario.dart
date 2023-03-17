import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class ModelFuncionario {
  factory ModelFuncionario.fromJson(Map<String, dynamic> json) {
    return ModelFuncionario(
      json['id_funcionario'],
      json['ci_funcionario'],
      json['id_sede'],
      json['nombre_funcionario'],
      json['telefono_funcionario'],
      json['correo_funcionario'],
      DateFormat('yyy-MM-dd')
          .format(DateTime.parse(json['fecha_inicio_funcionario'].toString())),
      double.parse(json['sueldo_funcionario'].toString()),
      json['hora_entrada_funcionario'],
      json['hora_salida_funcionario'],
    );
  }
  ModelFuncionario(
      this.idFuncionario,
      this.ciFuncionario,
      this.idSede,
      this.nombreFuncionario,
      this.telefonoFuncionario,
      this.correoFuncionario,
      this.fechaInicioFuncionario,
      this.sueldoFuncionario,
      this.horaEntradaFuncionario,
      this.horaSalidaFuncionario);
  int idFuncionario;
  String ciFuncionario;
  int idSede;
  String nombreFuncionario;
  String telefonoFuncionario;
  String correoFuncionario;
  String fechaInicioFuncionario;
  double sueldoFuncionario;
  String horaEntradaFuncionario;
  String horaSalidaFuncionario;
}

class FuncionarioDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  FuncionarioDataSource(List<ModelFuncionario> transactions) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'Id', value: dataGridRow.idFuncionario),
              DataGridCell<String>(
                  columnName: 'Ci', value: dataGridRow.ciFuncionario),
              DataGridCell<String>(
                  columnName: 'Nombre', value: dataGridRow.nombreFuncionario),
              DataGridCell<String>(
                  columnName: 'Telefono',
                  value: dataGridRow.telefonoFuncionario),
              DataGridCell<String>(
                  columnName: 'Correo', value: dataGridRow.correoFuncionario),
              DataGridCell<String>(
                  columnName: 'Fecha de Inicio',
                  value: dataGridRow.fechaInicioFuncionario),
              DataGridCell<double>(
                  columnName: 'Sueldo', value: dataGridRow.sueldoFuncionario),
              DataGridCell<String>(
                  columnName: 'Entrada',
                  value: dataGridRow.horaEntradaFuncionario),
              DataGridCell<String>(
                  columnName: 'Salida',
                  value: dataGridRow.horaSalidaFuncionario),
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
    NumberFormat f = NumberFormat("#,##0.00", "es_AR");
    String data;
    return DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == 'Sueldo') {
            data = f.format(dataGridCell.value);
          } else {
            data = dataGridCell.value.toString();
          }
          return Container(
            alignment: AlignmentDirectional.center,
            child: Text(
              data,
              textAlign: TextAlign.center,
            ),
          );
        }).toList());
  }
}
