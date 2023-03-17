import 'package:flutter/material.dart';

import '../models/model_funcionario.dart';

class ModalList extends StatefulWidget {
  const ModalList(
      {super.key,
      required this.listaFuncionarios,
      this.idTextController,
      this.funcionarioTextController});
  final TextEditingController? idTextController;
  final TextEditingController? funcionarioTextController;
  final List<ModelFuncionario> listaFuncionarios;

  @override
  State<ModalList> createState() => _ModalListState();
}

class _ModalListState extends State<ModalList> {
  final bfColor = Colors.blue.shade600.withOpacity(0.7);

  final bfColorBtn = Colors.indigo.shade900.withOpacity(0.7);

  final bfTextStyle = const TextStyle(
    shadows: [
      Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 12)
    ],
    color: Colors.white,
    fontSize: 16,
  );

  final ShapeBorder bfShape = RoundedRectangleBorder(
      side: BorderSide.merge(const BorderSide(color: Colors.white),
          const BorderSide(color: Colors.white)),
      borderRadius: BorderRadius.circular(10.0));
  var busquedaController = TextEditingController();
  List<ModelFuncionario> listaFiltrada = [];
  @override
  Widget build(BuildContext context) {
    var colorPrincipal = Colors.white;
    var colorSecundario = Colors.blue.shade500;
    var colorResaltante = Colors.indigo.shade900;
    var shadowPrincipal =
        const Shadow(color: Colors.black38, offset: Offset(1, 1));

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

    if (busquedaController.text.trim() == '') {
      listaFiltrada = widget.listaFuncionarios;
    } else {
      listaFiltrada = widget.listaFuncionarios.where((element) {
        return element.nombreFuncionario
            .toLowerCase()
            .contains(busquedaController.text.trim().toLowerCase());
      }).toList();
    }

    return AlertDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        shape: cardShape,
        backgroundColor: colorSecundario,
        titleTextStyle: cardTextStyle,
        actions: [
          TextField(
            controller: busquedaController,
            onChanged: (value) {
              setState(() {});
            },
            style: cardSubTextStyle,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: Text(
                  'Buscar funcionario',
                  style: cardSubTextStyle,
                )),
          )
        ],
        title: Row(
          children: const [
            Expanded(child: Text('Id')),
            Expanded(flex: 3, child: Text('Funcionario'))
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.width,
          child: Material(
            textStyle: const TextStyle(color: Colors.black87, fontSize: 18),
            elevation: 4,
            shape: bfShape,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: listaFiltrada.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.5, horizontal: 3),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black54))),
                    child: InkWell(
                      onTap: () {
                        widget.idTextController!.text =
                            listaFiltrada[index].idFuncionario.toString();
                        widget.funcionarioTextController!.text =
                            listaFiltrada[index].nombreFuncionario.toString();
                        Navigator.pop(context);
                      },
                      child: Row(children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              '${listaFiltrada[index].idFuncionario}',
                            )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              listaFiltrada[index].nombreFuncionario,
                            ))
                      ]),
                    ),
                  );
                }),
          ),
        ));
  }
}
