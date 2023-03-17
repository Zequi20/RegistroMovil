import 'package:flutter/material.dart';
import 'package:bio_farm/screenParams/arguments.dart';
import 'package:flutter/services.dart';

class ScreenGestion extends StatelessWidget {
  const ScreenGestion({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GestionArguments;

    var colorPrincipal = Colors.white;
    var colorSecundario = Colors.blue.shade500;
    var colorResaltante = Colors.indigo.shade900;
    var shadowPrincipal =
        const Shadow(color: Colors.black38, offset: Offset(1, 1));

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
              elevation: 0,
              iconTheme: IconThemeData(color: colorResaltante),
              centerTitle: true,
              title: Text(
                args.nombreSede.toUpperCase(),
                textAlign: TextAlign.center,
                style: titleTextStyle,
              ),
              backgroundColor: colorPrincipal,
              actions: [
                IconButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    icon: const Icon(Icons.exit_to_app))
              ],
            ),
            body: ListView(padding: const EdgeInsets.all(12.0), children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('Ingresos',
                        arguments:
                            GestionArguments(args.idSede, args.nombreSede));
                  },
                  shape: cardShape,
                  leading: Icon(
                    Icons.account_balance_wallet,
                    size: 44,
                    color: colorPrincipal,
                  ),
                  subtitle: Text(
                    'Gestionar el registro de ingresos en ${args.nombreSede}',
                    style: cardSubTextStyle,
                  ),
                  tileColor: colorSecundario,
                  contentPadding: const EdgeInsets.all(12.0),
                  title: Text(
                    'Ingresos',
                    style: cardTextStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('Gastos',
                        arguments:
                            GestionArguments(args.idSede, args.nombreSede));
                  },
                  shape: cardShape,
                  leading: Icon(
                    Icons.account_balance,
                    size: 44,
                    color: colorPrincipal,
                  ),
                  subtitle: Text(
                    'Gestionar el registro de gastos en ${args.nombreSede}',
                    style: cardSubTextStyle,
                  ),
                  tileColor: colorSecundario,
                  contentPadding: const EdgeInsets.all(12.0),
                  title: Text(
                    'Gastos',
                    style: cardTextStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('Retiros',
                        arguments:
                            GestionArguments(args.idSede, args.nombreSede));
                  },
                  shape: cardShape,
                  leading: Icon(
                    Icons.handshake,
                    size: 44,
                    color: colorPrincipal,
                  ),
                  subtitle: Text(
                    'Gestionar el registro de retiros en ${args.nombreSede}',
                    style: cardSubTextStyle,
                  ),
                  tileColor: colorSecundario,
                  contentPadding: const EdgeInsets.all(12.0),
                  title: Text(
                    'Retiros',
                    style: cardTextStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('Funcionarios',
                        arguments:
                            GestionArguments(args.idSede, args.nombreSede));
                  },
                  shape: cardShape,
                  leading: Icon(
                    Icons.account_box,
                    size: 44,
                    color: colorPrincipal,
                  ),
                  subtitle: Text(
                    'Gestionar el registro de funcionarios en ${args.nombreSede}',
                    style: cardSubTextStyle,
                  ),
                  tileColor: colorSecundario,
                  contentPadding: const EdgeInsets.all(12.0),
                  title: Text(
                    'Funcionarios',
                    style: cardTextStyle,
                  ),
                ),
              )
            ])));
  }
}
