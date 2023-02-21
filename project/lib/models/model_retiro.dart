import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ModelRetiro {
  factory ModelRetiro.fromJson(Map<String, dynamic> json) {
    return ModelRetiro(
      json['id_retiro'],
      json['id_sede'],
      double.parse(json['valor_retiro'].toString()),
      DateFormat('yyy-mm-dd')
          .format(DateTime.parse(json['fecha_retiro'].toString())),
      json['hora_retiro'].toString(),
      json['motivo_retiro'].toString(),
      json['funcionario_retiro'].toString(),
    );
  }
  ModelRetiro(this.idRetiro, this.idSede, this.valorRetiro, this.fechaRetiro,
      this.horaRetiro, this.motivoRetiro, this.funcionarioRetiro);
  int idRetiro;
  int idSede;
  double valorRetiro;
  String fechaRetiro;
  String horaRetiro;
  String motivoRetiro;
  String funcionarioRetiro;
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
                  columnName: 'Hora', value: dataGridRow.horaRetiro),
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
