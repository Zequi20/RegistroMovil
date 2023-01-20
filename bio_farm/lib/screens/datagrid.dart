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
  List<ModelTransaction> _transactions = [];
  //List<ModelTransaction> _searched = [];
  late TransactionDataSource _transactionDataSource;

  Future getTransactionData(String url) async {
    var response = await http.get(Uri.parse(url));
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

  final DataGridController _dataGridController = DataGridController();
  var link = 'http://localhost:8474/ingresos';
  bool visible = false;
  Icon searchIcon = const Icon(Icons.search);
  var queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
                onPressed: () {
                  var selected = _dataGridController.selectedRows;
                  if (selected.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actions: [
                              TextButton(
                                  style: const ButtonStyle(),
                                  onPressed: () async {
                                    var headers = {
                                      'Content-Type':
                                          'application/x-www-form-urlencoded'
                                    };
                                    var request = http.Request(
                                        'DELETE',
                                        Uri.parse(
                                            'http://localhost:8474/ingresos/borrar'));
                                    String idList = '';
                                    for (var element in selected) {
                                      idList +=
                                          '${element.getCells().first.value},';
                                    }

                                    request.bodyFields = {'id': '$idList 0'};
                                    request.headers.addAll(headers);

                                    http.StreamedResponse response =
                                        await request.send();

                                    if (response.statusCode == 200) {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Borrar registro'),
                                              content: const Text(
                                                  'Operacion exitosa'),
                                              actions: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(
                                                        Icons.check,
                                                        color: Colors.green))
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  child: const Text("CONFIRMAR")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('CANCELAR'))
                            ],
                            title: const Text("CONFIRMAR OPERACION"),
                            content: Text(
                                "Segur@ de que quieres borrar ${selected.length} registros?\nEsto es irreversible para la eternidad"),
                          );
                        });
                  }
                },
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                )),
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [
                Visibility(
                  visible: visible,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width) * (2 / 3),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      controller: queryController,
                      onChanged: (query) {
                        if (query.isEmpty) {
                          setState(() {
                            link = 'http://localhost:8474/ingresos';
                          });
                        } else {
                          setState(() {
                            link =
                                'http://localhost:8474/ingresos/buscar?data=$query';
                          });
                        }
                      },
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (visible) {
                      setState(() {
                        visible = false;
                        searchIcon = const Icon(Icons.search);
                        queryController.clear();
                        link = 'http://localhost:8474/ingresos';
                      });
                    } else {
                      setState(() {
                        visible = true;
                        searchIcon = const Icon(Icons.close);
                      });
                    }
                  },
                  icon: searchIcon,
                  color: Colors.white,
                )
              ],
              title: const Text('Visualizador de registro'),
              backgroundColor: Colors.indigo.shade900,
            ),
            body: FutureBuilder(
              future: getTransactionData(link),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? SfDataGrid(
                        showCheckboxColumn: true,
                        frozenColumnsCount: 1,
                        isScrollbarAlwaysShown: true,
                        controller: _dataGridController,
                        selectionMode: SelectionMode.multiple,
                        source: _transactionDataSource,
                        columns: getColumns(),
                      )
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
