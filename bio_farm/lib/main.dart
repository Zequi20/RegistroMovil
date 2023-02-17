import 'package:bio_farm/screens/gastos_registro.dart';
import 'package:bio_farm/screens/graficos.dart';
import 'package:bio_farm/screens/ingresos_registro.dart';
import 'package:bio_farm/screens/funcionarios_registro.dart';
import 'package:flutter/material.dart';
import 'package:bio_farm/screens/gestion.dart';
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
      title: 'GestionBioFarm',
      routes: {
        'Sedes': (context) => const ScreenSedes(),
        'Gestion': (context) => const ScreenGestion(),
        'Ingresos': (context) => const ScreenIngresosRegistro(),
        'Gastos': (context) => const ScreenGastosRegistro(),
        'Funcionarios': (context) => const ScreenFuncionariosRegistro(),
        'Graph': ((context) => const GraphScreen())
      },
      initialRoute: 'Sedes',
    );
  }
}
