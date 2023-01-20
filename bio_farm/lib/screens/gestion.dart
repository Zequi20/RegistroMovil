import 'package:flutter/material.dart';
import 'my_classes/my_widgets.dart';
import 'package:bio_farm/other/arguments.dart';

class ScreenGestion extends StatelessWidget {
  const ScreenGestion({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GestionArguments;
    final sede = args.sede.toLowerCase();

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'GESTION',
          textAlign: TextAlign.center,
        )),
        backgroundColor: Colors.indigo.shade900,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: GridView.count(
        crossAxisSpacing: 1,
        mainAxisSpacing: 2,
        crossAxisCount: 1,
        children: <Widget>[
          CardButton(
              icon: const Icon(
                Icons.auto_graph,
                color: Colors.white,
                size: 40,
              ),
              title: 'INGRESOS',
              description: 'Gestiona los ingresos de la sede $sede',
              onTap: () {
                Navigator.of(context).pushNamed('Ingresos',
                    arguments: GestionArguments(sede, 'Mensaje de prueba'));
              }),
          CardButton(
              icon: const Icon(
                Icons.money_off_csred,
                color: Colors.white,
                size: 40,
              ),
              title: 'GASTOS',
              description: 'Gestiona los gastos de la sede $sede',
              onTap: () {}),
          CardButton(
              icon: const Icon(
                Icons.storefront,
                color: Colors.white,
                size: 40,
              ),
              title: 'INVENTARIO',
              description: 'Gestiona el inventario de la sede $sede',
              onTap: () {}),
          CardButton(
              icon: const Icon(
                Icons.group,
                color: Colors.white,
                size: 40,
              ),
              title: 'FUNCIONARIOS',
              description: 'Gestiona los funcionarios de la sede $sede',
              onTap: () {}),
          CardButton(
              icon: const Icon(
                Icons.pie_chart_rounded,
                color: Colors.white,
                size: 40,
              ),
              title: 'ESTADISTICAS',
              description: 'Estadisticas generales de la sede $sede',
              onTap: () {})
        ],
      ),
    ));
  }
}
