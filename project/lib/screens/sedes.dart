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
  final String sedesUrl = 'http://132.255.166.73:8474/sedes';

  List<Sede> lista = [];

  var colorPrincipal = Colors.white;
  var colorSecundario = Colors.blue.shade500;
  var colorResaltante = Colors.indigo.shade900;
  var shadowPrincipal =
      const Shadow(color: Colors.black38, offset: Offset(1, 1));
  @override
  Widget build(BuildContext context) {
    var titleTextStyle = TextStyle(
      color: colorResaltante,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
    var cardTextStyle = TextStyle(
        color: colorPrincipal,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        shadows: [shadowPrincipal]);

    var cardSubTextStyle = TextStyle(
        color: colorPrincipal,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        shadows: [shadowPrincipal]);

    var cardShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: colorResaltante));
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorPrincipal,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [colorPrincipal, colorSecundario])),
        ),
        iconTheme: IconThemeData(color: colorResaltante),
        elevation: 0,
        centerTitle: true,
        title: Text(
          style: titleTextStyle,
          'SUCURSALES',
          textAlign: TextAlign.center,
        ),
        backgroundColor: colorPrincipal,
        actions: [
          IconButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              icon: const Icon(
                Icons.exit_to_app,
              )),
        ],
      ),
      body: FutureBuilder(
          future: getSedesData(sedesUrl),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    scrollDirection: Axis.vertical,
                    itemCount: lista.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          shape: cardShape,
                          onTap: () {
                            Navigator.of(context).pushNamed('Gestion',
                                arguments: GestionArguments(
                                    lista[i].idSede, lista[i].nombreSede));
                          },
                          trailing: IconButton(
                            onPressed: () {
                              infoDialog(lista, i, cardTextStyle, cardShape);
                            },
                            icon: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 45,
                              shadows: [shadowPrincipal],
                            ),
                          ),
                          leading: Icon(
                            Icons.arrow_forward_ios,
                            size: 45,
                            color: Colors.white,
                            shadows: [shadowPrincipal],
                          ),
                          subtitle: Text(
                            'Ubicado en ${lista[i].ubicacionSede}',
                            style: cardSubTextStyle,
                          ),
                          tileColor: colorSecundario,
                          contentPadding: const EdgeInsets.all(12.0),
                          title: Text(
                            lista[i].nombreSede,
                            style: cardTextStyle,
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue.shade600.withOpacity(0.7),
                      backgroundColor: Colors.white,
                      strokeWidth: 8,
                    ),
                  );
          }),
    ));
  }

  Future getSedesData(String url) async {
    lista.clear();
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

  dynamic infoDialog(List<dynamic> lista, int i, cardTextStyle, cardShape) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titleTextStyle: cardTextStyle,
            contentTextStyle: cardTextStyle,
            shape: cardShape,
            iconColor: colorPrincipal,
            backgroundColor: colorSecundario,
            actions: [
              TextButton(
                  child: Text(
                    'Aceptar',
                    style: cardTextStyle,
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
