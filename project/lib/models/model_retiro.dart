import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ModelRetiro {
  factory ModelRetiro.fromJson(Map<String, dynamic> json) {
    return ModelRetiro(
        json['id_retiro'],
        json['funcionario_retiro'],
        json['fecha_retiro'].toString(),
        json['motivo_retiro'],
        json['valor_retiro']);
  }
  ModelRetiro(this.idRetiro, this.funcionarioRetiro, this.fechaRetiro,
      this.motivoRetiro, this.valorRetiro);
  int idRetiro;
  String funcionarioRetiro;
  double valorRetiro;
  String fechaRetiro;
  String motivoRetiro;
}

class TransactionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  TransactionDataSource(List<ModelRetiro> transactions) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'Id', value: dataGridRow.idRetiro),
              DataGridCell<String>(
                  columnName: 'Funcionario',
                  value: dataGridRow.funcionarioRetiro),
              DataGridCell<double>(
                  columnName: 'Valor', value: dataGridRow.valorRetiro),
              DataGridCell<String>(
                  columnName: 'Fecha', value: dataGridRow.fechaRetiro),
              DataGridCell<String>(
                  columnName: 'Motivo', value: dataGridRow.motivoRetiro)
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
