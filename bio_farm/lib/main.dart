import 'package:bio_farm/screens/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:bio_farm/screens/gestion.dart';
import 'package:bio_farm/screens/ingresos.dart';
import 'package:bio_farm/screens/ingresos_agregar.dart';
import 'screens/sedes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BioFarmApp',
      routes: {
        'Sedes': (context) => const ScreenSedes(),
        'Gestion': (context) => const ScreenGestion(),
        'Ingresos': (context) => const ScreenIngresos(),
        'IngresosAgregar': (context) => const ScreenIngresosAgregar(),
        'IngresosBorrar': (context) => const ScreenDataGrids(),
      },
      initialRoute: 'Sedes',
    );
  }
}
