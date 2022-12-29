import 'dart:convert';
import 'package:bio_farm/models/model_transaction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

class ScreenDataGrids extends StatefulWidget {
  const ScreenDataGrids({super.key});

  @override
  State<ScreenDataGrids> createState() => _ScreenDataGridsState();
}

class _ScreenDataGridsState extends State<ScreenDataGrids> {
  late TransactionDataSource _transactionDataSource;
  List<ModelTransaction> _transactions = [];

  Future getTransactionData() async {
    var response = await http.get(Uri.parse('http://localhost:8474/ingresos'));
    List list = json.decode(response.body);
    _transactions = listToModel(list);
    _transactionDataSource = TransactionDataSource(_transactions);
    return _transactions;
  }

  List<ModelTransaction> listToModel(List mapa) {
    List<ModelTransaction> lista = [];
    for (var v in mapa) {
      lista.add(ModelTransaction.fromJson(v));
    }

    return lista;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Visualizador de registro'),
              backgroundColor: Colors.indigo.shade900,
            ),
            body: FutureBuilder(
              future: getTransactionData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? SfDataGrid(
                        source: _transactionDataSource, columns: getColumns())
                    : const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      );
              },
            )));
  }

  List<GridColumn> getColumns() {
    return [
      GridColumn(
          columnName: 'ID',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('ID'),
          )),
      GridColumn(
          columnName: 'Detalles',
          columnWidthMode: ColumnWidthMode.none,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: const Text('Detalles'),
          )),
      GridColumn(
          columnName: 'Valor',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Valor'),
          )),
      GridColumn(
          columnName: 'Fecha',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Fecha'),
          )),
      GridColumn(
          columnName: 'Descuento',
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text('Descuento'),
          ))
    ];
  }
}
