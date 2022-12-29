import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ModelTransaction {
  factory ModelTransaction.fromJson(Map<String, dynamic> json) {
    return ModelTransaction(json['id_ingreso'], json['concepto_ingreso'], 0.0,
        0.0, DateTime(2022, 12, 3, 6));
  }
  ModelTransaction(this.transactionId, this.transactionConcept,
      this.transactionValue, this.transactionDesc, this.transactionDate);
  int transactionId;
  double transactionValue;
  double transactionDesc;
  String transactionConcept;
  DateTime transactionDate;
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
              DataGridCell<DateTime>(
                  columnName: 'Fecha', value: dataGridRow.transactionDate),
              DataGridCell<double>(
                  columnName: 'Descuento', value: dataGridRow.transactionDesc),
            ]))
        .toList(growable: false);
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
