import 'package:flutter/material.dart';

class ScreenIngresosBorrar extends StatefulWidget {
  const ScreenIngresosBorrar({super.key});

  @override
  State<ScreenIngresosBorrar> createState() => _ScreenIngresosBorrarState();
}

class _ScreenIngresosBorrarState extends State<ScreenIngresosBorrar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold with appbar ans body.
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              label: Text(
            'Buscar',
            style: TextStyle(color: Colors.white),
          )),
          keyboardType: TextInputType.text,
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
              // Datatable widget that have the property columns and rows.
              columns: const [
                // Set the name of the column
                DataColumn(
                  label: Text('ID'),
                ),
                DataColumn(
                  label: Text('Concepto'),
                ),
                DataColumn(
                  label: Text('Valor'),
                ),
                DataColumn(
                  label: Text('Descuento'),
                ),
              ], rows: const [
            // Set the values to the columns
            DataRow(cells: [
              DataCell(Text("1")),
              DataCell(Text("holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")),
              DataCell(Text("Anderson")),
              DataCell(Text("18")),
            ]),
            DataRow(cells: [
              DataCell(Text("2")),
              DataCell(Text("John")),
              DataCell(Text("Anderson")),
              DataCell(Text("24")),
            ]),
          ]),
        ),
      ),
    );
  }
}
