import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class ModelTransaction {
  factory ModelTransaction.fromJson(Map<String, dynamic> json) {
    return ModelTransaction(
        json['id_ingreso'],
        json['concepto_ingreso'],
        double.parse(json['valor_ingreso'].toString()),
        double.parse(json['descuento_ingreso'].toString()),
        DateFormat('yyy-mm-dd')
            .format(DateTime.parse(json['fecha_ingreso'].toString())),
        json['hora_ingreso'].toString());
  }
  ModelTransaction(
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

  TransactionDataSource(List<ModelTransaction> transactions) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'id', value: dataGridRow.transactionId),
              DataGridCell<String>(
                  columnName: 'Concepto',
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
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: AlignmentDirectional.center,
          child: SingleChildScrollView(
            child: Text(
              dataGridCell.value.toString(),
              textAlign: TextAlign.center,
            ),
          ));
    }).toList());
  }
}
