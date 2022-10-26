import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/my_widgets.dart';
import 'package:bio_farm/other/arguments.dart';

class ScreenSedes extends StatelessWidget {
  const ScreenSedes({super.key});

  @override
  Widget build(BuildContext context) {
    var lista = ['CAAZAPA', 'YUTY', 'SAN JUAN NEP'];
    return SafeArea(
        child: Scaffold(
      floatingActionButton: const Icon(
        Icons.account_tree,
        color: Color.fromARGB(255, 26, 35, 126),
        size: 80,
      ),
      appBar: AppBar(
        title: const Center(
            child: Text(
          'SEDES',
          textAlign: TextAlign.center,
        )),
        backgroundColor: Colors.indigo.shade900,
        actions: [
          IconButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: lista.length,
        itemBuilder: (BuildContext context, int index) {
          return CardButton(
            icon: const Icon(
              Icons.domain,
              size: 40,
              color: Colors.white,
            ),
            title: '\n${lista[index]}',
            description: 'Descripcion sede ${lista[index].toLowerCase()}',
            onTap: () {
              Navigator.of(context).pushNamed('Gestion',
                  arguments:
                      GestionArguments(lista[index], 'Mensaje de prueba'));
            },
          );
        },
      ),
    ));
  }
}
