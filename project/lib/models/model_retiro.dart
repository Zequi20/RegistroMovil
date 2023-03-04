import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ModelRetiro {
  factory ModelRetiro.fromJson(Map<String, dynamic> json) {
    return ModelRetiro(
      json['id_retiro'],
      json['id_funcionario'],
      double.parse(json['valor_retiro'].toString()),
      DateFormat('yyy-mm-dd')
          .format(DateTime.parse(json['fecha_retiro'].toString())),
      json['hora_retiro'].toString(),
      json['motivo_retiro'].toString(),
      json['funcionario_retiro'].toString(),
    );
  }
  ModelRetiro(
      this.idRetiro,
      this.idFuncionario,
      this.valorRetiro,
      this.fechaRetiro,
      this.horaRetiro,
      this.motivoRetiro,
      this.funcionarioRetiro);
  int idRetiro;
  int idFuncionario;
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
              DataGridCell<int>(
                  columnName: 'Id Funcionario',
                  value: dataGridRow.idFuncionario),
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
    NumberFormat f = NumberFormat("#,##0.00", "es_AR");
    String data;
    return DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == 'Valor') {
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
