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
  bool ascendSort = true;
  List<DataRow> rows = [];
  NumberFormat f = NumberFormat("#,##0.00", "es_AR");
  @override
  Widget build(BuildContext context) {
    var titleTextStyle = TextStyle(
      color: colorResaltante,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );

    return Column(
      children: [
        Expanded(
          flex: 14,
          child: FutureBuilder(
            future: getHistorial('http://132.255.166.73:8474/pagos/historial'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<dynamic> data = snapshot.data;

                rows = List.from(data
                    .map((element) => DataRow(cells: [
                          DataCell(Text(element['id_registro'].toString())),
                          DataCell(Text(element['nombre_funcionario'])),
                          DataCell(Text(element['nombre_Sede'])),
                          DataCell(Text(f.format(element['salario_registro']))),
                          DataCell(Text(f.format(element['plus_registro']))),
                          DataCell(Text(DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(element['fecha_registro'])))),
                          DataCell(Text(element['comentario_registro'])),
                        ]))
                    .toList());

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortAscending: ascendSort,
                      sortColumnIndex: 0,
                      columns: [
                        DataColumn(
                            label: const Text('ID'),
                            numeric: true,
                            onSort: (index, ascending) {
                              setState(() {});
                            }),
                        const DataColumn(label: Text('Funcionario')),
                        const DataColumn(label: Text('Sede')),
                        const DataColumn(
                            label: Text('Salario'), numeric: false),
                        const DataColumn(label: Text('Plus'), numeric: false),
                        const DataColumn(label: Text('Fecha'), numeric: false),
                        const DataColumn(label: Text('Comentario')),
                      ],
                      rows: rows,
                    ),
                  ),
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
        Expanded(
          child: TextFormField(
            onChanged: (value) {},
            decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: 'Busqueda'),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  colorSecundario,
                  colorPrincipal,
                  colorSecundario
                ])),
            child: Center(
              child: Text(
                'Historial de pagos',
                style: titleTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future getHistorial(String url) async {
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List<dynamic> list = json.decode(response.body);

    if (ascendSort == true) {
      ascendSort = false;
      list.sort((a, b) => b['id_registro'].compareTo(a['id_registro']));
    } else {
      ascendSort = true;
      list.sort((a, b) => a['id_registro'].compareTo(b['id_registro']));
    }

    return list;
  }
}
