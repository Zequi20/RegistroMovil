import 'package:flutter/material.dart';
import 'package:bio_farm/screens/widgets/my_widgets.dart';
//import 'package:bio_farm/other/elementos.dart';

class ScreenIngresosAgregar extends StatefulWidget {
  const ScreenIngresosAgregar({super.key});

  @override
  State<ScreenIngresosAgregar> createState() => _ScreenIngresosAgregarState();
}

class _ScreenIngresosAgregarState extends State<ScreenIngresosAgregar> {
  var lista = ['Elem1', 'Elem2'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'AGREGAR INGRESO',
          textAlign: TextAlign.center,
        )),
        backgroundColor: Colors.indigo.shade900,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Form(
          child: Column(
        children: [
          const CardTitle(
              title: ' Detalles del registro',
              icon: Icon(
                Icons.attach_money_outlined,
                color: Colors.white,
              )),
          const Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(label: Text('Concepto de Ingreso')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: const [
                Expanded(
                    child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: Text('Valor de Ingreso (En Guaranies)')),
                )),
                VerticalDivider(),
                Expanded(
                    child: TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(label: Text('Descuento (En Guaranies)')),
                ))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: CardTitle(
              title: ' Ganancia Total: ',
              icon: Icon(
                Icons.money,
                color: Colors.white,
              ),
            ),
          )
        ],
      )),
    ));
  }
}
