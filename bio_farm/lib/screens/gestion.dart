import 'package:flutter/material.dart';
import 'package:bio_farm/screenParams/arguments.dart';
import 'package:flutter/services.dart';

class ScreenGestion extends StatelessWidget {
  const ScreenGestion({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GestionArguments;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'GESTION',
          textAlign: TextAlign.center,
        )),
        backgroundColor: Colors.indigo.shade900.withOpacity(0.7),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              strokeAlign: StrokeAlign.outside, width: 1, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.6,
                scale: 0.7,
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXSEk-x5K-zS2LOFQzL8Z9KcxSQ1GZhtcCPggbjg0dsl98cZE2qZ7pJ2MgB5tr90rBRtY&usqp=CAU'))),
        child: getRegistros(args, context),
      ),
    ));
  }

  Widget getRegistros(args, context) {
    var bfTextStyle = const TextStyle(
      shadows: [
        Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 12)
      ],
      color: Colors.white,
      fontSize: 16,
    );
    return ListView(padding: const EdgeInsets.all(12.0), children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
            color: Colors.white.withOpacity(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            elevation: 5,
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('Ingresos',
                    arguments: GestionArguments(args.idSede, args.nombreSede));
              },
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(12.0)),
              leading: const Icon(
                Icons.account_balance_wallet,
                size: 32,
                color: Colors.white,
              ),
              subtitle: Text(
                'Gestionar el registro de ingresos en ${args.nombreSede}',
                style: bfTextStyle,
              ),
              tileColor: Colors.blue.shade600.withOpacity(0.7),
              contentPadding: const EdgeInsets.all(12.0),
              title: Text(
                'Ingresos',
                style: bfTextStyle,
              ),
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
            color: Colors.white.withOpacity(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            elevation: 5,
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('Gastos',
                    arguments: GestionArguments(args.idSede, args.nombreSede));
              },
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(12.0)),
              leading: const Icon(
                Icons.account_balance,
                size: 32,
                color: Colors.white,
              ),
              subtitle: Text(
                'Gestionar el registro de gastos en ${args.nombreSede}',
                style: bfTextStyle,
              ),
              tileColor: Colors.blue.shade600.withOpacity(0.7),
              contentPadding: const EdgeInsets.all(12.0),
              title: Text(
                'Gastos',
                style: bfTextStyle,
              ),
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
            color: Colors.white.withOpacity(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            elevation: 5,
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('Funcionarios',
                    arguments: GestionArguments(args.idSede, args.nombreSede));
              },
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(12.0)),
              leading: const Icon(
                Icons.account_box,
                size: 32,
                color: Colors.white,
              ),
              subtitle: Text(
                'Gestionar el registro de funcionarios en ${args.nombreSede}',
                style: bfTextStyle,
              ),
              tileColor: Colors.blue.shade600.withOpacity(0.7),
              contentPadding: const EdgeInsets.all(12.0),
              title: Text(
                'Funcionarios',
                style: bfTextStyle,
              ),
            )),
      )
    ]);
  }
}
