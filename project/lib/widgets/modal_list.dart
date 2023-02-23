import 'package:flutter/material.dart';

import '../models/model_funcionario.dart';

class ModalList extends StatelessWidget {
  ModalList(
      {super.key,
      required this.listaFuncionarios,
      this.idTextController,
      this.funcionarioTextController});
  final TextEditingController? idTextController;
  final TextEditingController? funcionarioTextController;
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
  final List<ModelFuncionario> listaFuncionarios;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        shape: bfShape,
        backgroundColor: bfColor,
        titleTextStyle: bfTextStyle,
        actions: [
          TextField(
            style: bfTextStyle,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: Text(
                  'Buscar funcionario',
                  style: bfTextStyle,
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
                itemCount: listaFuncionarios.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.5, horizontal: 3),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black54))),
                    child: InkWell(
                      onTap: () {
                        idTextController!.text =
                            listaFuncionarios[index].idFuncionario.toString();
                        funcionarioTextController!.text =
                            listaFuncionarios[index]
                                .nombreFuncionario
                                .toString();
                        Navigator.pop(context);
                      },
                      child: Row(children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              '${listaFuncionarios[index].idFuncionario}',
                            )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              listaFuncionarios[index].nombreFuncionario,
                            ))
                      ]),
                    ),
                  );
                }),
          ),
        ));
  }
}
