import 'package:bio_farm/screens/gastos_registro.dart';
import 'package:bio_farm/screens/ingresos_registro.dart';
import 'package:bio_farm/screens/funcionarios_registro.dart';
import 'package:bio_farm/screens/inicio.dart';
import 'package:bio_farm/screens/pagos.dart';
import 'package:bio_farm/screens/retiros_registro.dart';
import 'package:flutter/material.dart';
import 'package:bio_farm/screens/gestion.dart';
import 'screens/sedes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    var colorResaltante = Colors.indigo.shade900;
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(titleMedium: TextStyle(color: colorResaltante)),
          inputDecorationTheme: InputDecorationTheme(
              counterStyle: TextStyle(color: colorResaltante),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorResaltante)),
              labelStyle: TextStyle(color: colorResaltante))),
      debugShowCheckedModeBanner: false,
      title: 'GestionBioFarm',
      routes: {
        'Sedes': (context) => const ScreenSedes(),
        'Gestion': (context) => const ScreenGestion(),
        'Ingresos': (context) => const ScreenIngresosRegistro(),
        'Gastos': (context) => const ScreenGastosRegistro(),
        'Funcionarios': (context) => const ScreenFuncionariosRegistro(),
        'Pagos': (context) => const ScreenPagos(),
        'Retiros': (context) => const ScreenRetirosRegistro(),
        'Inicio': (context) => const ScreenInicio()
      },
      initialRoute: 'Inicio',
    );
  }
}
