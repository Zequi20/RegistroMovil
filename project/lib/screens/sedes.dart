import 'package:bio_farm/widgets/donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../screenParams/arguments.dart';
import '../models/model_sedes.dart';
import 'dart:convert';

class ScreenSedes extends StatefulWidget {
  const ScreenSedes({super.key});

  @override
  State<ScreenSedes> createState() => _ScreenSedesState();
}

class _ScreenSedesState extends State<ScreenSedes> {
  final String sedesUrl = 'http://192.168.0.7:8474/sedes';

  List<Sede> lista = [];

  var bfColor = Colors.blue.shade600.withOpacity(0.7);
  var bfColorBtn = Colors.indigo.shade900.withOpacity(0.7);
  var bfTextStyle = const TextStyle(
    shadows: [
      Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 12)
    ],
    color: Colors.white,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              strokeAlign: BorderSide.strokeAlignOutside,
              width: 1,
              color: Colors.white),
        ),
        title: const Center(
            child: Text(
          style: TextStyle(
            shadows: [
              Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 4),
            ],
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          'SUCURSALES',
          textAlign: TextAlign.center,
        )),
        backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
        actions: [
          IconButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: FutureBuilder(
          future: getSedesData(sedesUrl),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.hasData
                ? sedesBody(lista)
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue.shade600.withOpacity(0.7),
                      backgroundColor: Colors.white,
                      strokeWidth: 8,
                    ),
                  );
          }),
      bottomNavigationBar: const SizedBox(
        height: 300,
        child: AspectRatio(
          aspectRatio: 1.9,
          child: DonutChart(),
        ),
      ),
    ));
  }

  Future getSedesData(String url) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headers);

    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    List list = json.decode(response.body);
    for (var element in list) {
      lista.add(Sede.fromJson(element));
    }

    return lista;
  }

  Widget sedesBody(List<Sede> lista) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              opacity: 1,
              scale: 1,
              image: NetworkImage(
                  'https://st2.depositphotos.com/47577860/46278/v/450/depositphotos_462784056-stock-illustration-analytics-bar-chart-icon-outline.jpg'))),
      child: getSedes(),
    );
  }

  Widget getSedes() {
    var bfTextStyle = const TextStyle(
      shadows: [
        Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 12)
      ],
      color: Colors.white,
      fontSize: 16,
    );
    ShapeBorder bfShape = RoundedRectangleBorder(
        side: BorderSide.merge(const BorderSide(color: Colors.white),
            const BorderSide(color: Colors.white)),
        borderRadius: BorderRadius.circular(10.0));
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      scrollDirection: Axis.vertical,
      itemCount: lista.length,
      itemBuilder: (BuildContext context, int i) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            color: Colors.white.withOpacity(0),
            shape: bfShape,
            elevation: 5,
            child: ListTile(
              shape: bfShape,
              onTap: () {
                Navigator.of(context).pushNamed('Gestion',
                    arguments:
                        GestionArguments(lista[i].idSede, lista[i].nombreSede));
              },
              trailing: IconButton(
                onPressed: () {
                  infoDialog(lista, i);
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              ),
              leading: const Icon(
                Icons.backup_table,
                size: 32,
                color: Colors.white,
              ),
              subtitle: Text(
                'Ubicado en ${lista[i].ubicacionSede}',
                style: bfTextStyle,
              ),
              tileColor: Colors.blue.shade600.withOpacity(0.7),
              contentPadding: const EdgeInsets.all(12.0),
              title: Text(
                lista[i].nombreSede,
                style: bfTextStyle,
              ),
            ),
          ),
        );
      },
    );
  }

  dynamic infoDialog(List<dynamic> lista, int i) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titleTextStyle: bfTextStyle,
            contentTextStyle: bfTextStyle,
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(12.0)),
            iconColor: Colors.white,
            backgroundColor: Colors.blue.shade600.withOpacity(0.6),
            actions: [
              TextButton(
                  child: Text(
                    'Aceptar',
                    style: bfTextStyle,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            title: Text(
              lista[i].nombreSede,
            ),
            content: Wrap(
              direction: Axis.vertical,
              children: [
                Text('Ubicacion: ${lista[i].ubicacionSede}'),
                Text('Cantidad de funcionarios: ${lista[i].funcionariosSede}'),
                Text('Telefono: ${lista[i].telefonoSede}'),
              ],
            ),
          );
        });
  }
}