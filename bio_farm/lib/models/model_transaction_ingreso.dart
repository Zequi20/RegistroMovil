import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class ModelTransactionIngreso {
  factory ModelTransactionIngreso.fromJson(Map<String, dynamic> json) {
    return ModelTransactionIngreso(
        json['id_ingreso'],
        json['concepto_ingreso'],
        double.parse(json['valor_ingreso'].toString()),
        double.parse(json['descuento_ingreso'].toString()),
        DateFormat('yyy-mm-dd')
            .format(DateTime.parse(json['fecha_ingreso'].toString())),
        json['hora_ingreso'].toString());
  }
  ModelTransactionIngreso(
      this.transactionId,
      this.transactionConcept,
      this.transactionValue,
      this.transactionDesc,
      this.transactionDate,
      this.transactionTime);
  int transactionId;
  double transactionValue;
  double transactionDesc;
  String transactionConcept;
  String transactionDate;
  String transactionTime;
}

class TransactionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  TransactionDataSource(List<ModelTransactionIngreso> transactions) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'Id', value: dataGridRow.transactionId),
              DataGridCell<String>(
                  columnName: 'Detalles',
                  value: dataGridRow.transactionConcept),
              DataGridCell<double>(
                  columnName: 'Valor', value: dataGridRow.transactionValue),
              DataGridCell<String>(
                  columnName: 'Fecha', value: dataGridRow.transactionDate),
              DataGridCell<String>(
                  columnName: 'Hora', value: dataGridRow.transactionTime),
              DataGridCell<double>(
                  columnName: 'Descuento', value: dataGridRow.transactionDesc),
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
