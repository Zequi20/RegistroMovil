import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class PagosHistorial extends StatefulWidget {
  const PagosHistorial({super.key});

  @override
  State<PagosHistorial> createState() => _PagosHistorialState();
}

class _PagosHistorialState extends State<PagosHistorial> {
  var colorResaltante = Colors.indigo.shade900;
  var colorSecundario = Colors.blue.shade500;
  var colorPrincipal = Colors.white;
  bool filtrar = false;
  String filtro = '';
  int cellIndex = 1;

  TextEditingController controlador = TextEditingController();

  NumberFormat f = NumberFormat("#,##0.00", "es_AR");
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getHistorial('http://132.255.166.73:8474/pagos/historial'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  if (value.trim() == '') {
                                    filtrar = false;
                                    filtro = '';
                                  } else {
                                    filtrar = true;
                                    filtro = value.toLowerCase().trim();
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search),
                                  hintText: 'Busqueda por...'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none),
                            elevation: 1,
                            onChanged: (value) {
                              setState(() {
                                cellIndex = value!;
                              });
                            },
                            value: cellIndex,
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('ID'),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Nombre'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('Sede'),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text('Salario'),
                              ),
                              DropdownMenuItem(
                                value: 4,
                                child: Text('Plus'),
                              ),
                              DropdownMenuItem(
                                value: 5,
                                child: Text('Fecha'),
                              ),
                              DropdownMenuItem(
                                value: 6,
                                child: Text('Comentario'),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Text('ID'),
                                numeric: true,
                              ),
                              DataColumn(label: Text('Funcionario')),
                              DataColumn(label: Text('Sede')),
                              DataColumn(
                                  label: Text('Salario'), numeric: false),
                              DataColumn(label: Text('Plus'), numeric: false),
                              DataColumn(label: Text('Fecha'), numeric: false),
                              DataColumn(label: Text('Comentario')),
                            ],
                            rows: getRows(filtrar, filtro, snapshot.data),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorResaltante,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  List<DataRow> getRows(bool filtrar, String filtro, var data) {
    List<DataRow> procesado = List.from(data
        .map((element) => DataRow(cells: [
              DataCell(Text(element['id_registro'].toString())),
              DataCell(Text(element['nombre_funcionario'])),
              DataCell(Text(element['nombre_Sede'])),
              DataCell(Text(f.format(element['salario_registro']))),
              DataCell(Text(f.format(element['plus_registro']))),
              DataCell(Text(DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(element['fecha_registro'])))),
              DataCell(Text(element['comentario_registro'])),
            ]))
        .toList());
    if (filtrar == false) {
      return procesado;
    } else {
      return procesado.where((element) {
        return (element.cells[cellIndex].child as Text)
            .data!
            .toLowerCase()
            .contains(filtro);
      }).toList();
    }
  }

  Future getHistorial(String url) async {
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List<dynamic> list = json.decode(response.body);

    return list;
  }
}
