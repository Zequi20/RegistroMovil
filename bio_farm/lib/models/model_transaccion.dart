import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class ModelTransaccion {
  factory ModelTransaccion.fromJson(Map<String, dynamic> json) {
    bool tipo;
    if (json['tipo_transaccion'] == 0) {
      tipo = false;
    } else {
      tipo = true;
    }
    return ModelTransaccion(
        json['id_transaccion'],
        json['id_sede'],
        tipo,
        double.parse(json['valor_transaccion'].toString()),
        DateFormat('yyy-mm-dd')
            .format(DateTime.parse(json['fecha_transaccion'].toString())),
        json['hora_transaccion'].toString(),
        json['observacion_transaccion']);
  }
  ModelTransaccion(
      this.idTransaccion,
      this.idSede,
      this.tipoTransaccion,
      this.valorTransaccion,
      this.fechaTransaccion,
      this.horaTransaccion,
      this.observacionTransaccion);
  int idTransaccion;
  int idSede;
  bool tipoTransaccion;
  double valorTransaccion;
  String fechaTransaccion;
  String horaTransaccion;
  String observacionTransaccion;
}

class TransactionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  TransactionDataSource(List<ModelTransaccion> transactions) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'Id', value: dataGridRow.idTransaccion),
              DataGridCell<double>(
                  columnName: 'Valor', value: dataGridRow.valorTransaccion),
              DataGridCell<String>(
                  columnName: 'Fecha', value: dataGridRow.fechaTransaccion),
              DataGridCell<String>(
                  columnName: 'Hora', value: dataGridRow.horaTransaccion),
              DataGridCell<String>(
                  columnName: 'Observacion',
                  value: dataGridRow.observacionTransaccion)
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
