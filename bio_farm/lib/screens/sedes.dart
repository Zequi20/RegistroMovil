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
  final String link = 'http://192.168.0.7:8474/sedes';

  List<Sede> lista = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                    strokeAlign: StrokeAlign.outside,
                    width: 1,
                    color: Colors.white),
              ),
              title: const Center(
                  child: Text(
                style: TextStyle(color: Colors.white),
                'SEDES',
                textAlign: TextAlign.center,
              )),
              backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
              actions: [
                IconButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    icon: const Icon(Icons.exit_to_app))
              ],
            ),
            body: FutureBuilder(
                future: getSedesData(link),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return snapshot.hasData
                      ? sedesBody(lista)
                      : Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade600.withOpacity(0.7),
                            backgroundColor: Colors.white,
                            strokeWidth: 8,
                          ),
                        );
                })));
  }

  Future getSedesData(String url) async {
    var response = await http.get(Uri.parse(url));
    List list = json.decode(response.body);
    for (var element in list) {
      lista.add(Sede.fromJson(element));
    }
    return lista;
  }

  /*  List<ModelTransactionIngreso> listToModel(List mapa) {
    List<ModelTransactionIngreso> lista = [];
    for (var v in mapa) {
      lista.add(ModelTransactionIngreso.fromJson(v));
    }

    return lista;
  }
 */
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
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      scrollDirection: Axis.vertical,
      itemCount: lista.length,
      itemBuilder: (BuildContext context, int i) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            color: Colors.white.withOpacity(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            elevation: 5,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(12.0)),
              onTap: () {
                Navigator.of(context).pushNamed('Gestion',
                    arguments: GestionArguments(
                        lista[i].nombreSede, 'Mensaje de prueba'));
              },
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(12.0)),
                          iconColor: Colors.white,
                          backgroundColor:
                              Colors.blue.shade600.withOpacity(0.6),
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
                            style: bfTextStyle,
                          ),
                          content: Text(
                            'Se muestra la cantidad de empleados, empleados en caja, direccion, ingresos y egresos totales cuando los datos esten disponibles en la base de datos del servidor',
                            style: bfTextStyle,
                          ),
                        );
                      });
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              ),
              leading: const Icon(
                Icons.query_stats,
                size: 32,
                color: Colors.white,
              ),
              subtitle: Text(
                'Ubicado ${lista[i].ubicacionSede}',
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
}
