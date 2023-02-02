import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class ModelTransactionGasto {
  factory ModelTransactionGasto.fromJson(Map<String, dynamic> json) {
    return ModelTransactionGasto(
        json['id_gasto'],
        json['concepto_gasto'],
        double.parse(json['valor_gasto'].toString()),
        DateFormat('yyy-mm-dd')
            .format(DateTime.parse(json['fecha_gasto'].toString())),
        json['hora_gasto'].toString());
  }
  ModelTransactionGasto(this.gastoId, this.gastoConcept, this.gastoValue,
      this.gastoDate, this.gastoTime);
  int gastoId;
  double gastoValue;
  String gastoConcept;
  String gastoDate;
  String gastoTime;
}

class TransactionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  TransactionDataSource(List<ModelTransactionGasto> transactions) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'Id', value: dataGridRow.gastoId),
              DataGridCell<String>(
                  columnName: 'Detalles', value: dataGridRow.gastoConcept),
              DataGridCell<double>(
                  columnName: 'Valor', value: dataGridRow.gastoValue),
              DataGridCell<String>(
                  columnName: 'Fecha', value: dataGridRow.gastoDate),
              DataGridCell<String>(
                  columnName: 'Hora', value: dataGridRow.gastoTime),
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
