import 'package:flutter/material.dart';
import 'my_classes/my_widgets.dart';

class ScreenIngresos extends StatefulWidget {
  const ScreenIngresos({super.key});

  @override
  State<ScreenIngresos> createState() => _ScreenIngresosState();
}

class _ScreenIngresosState extends State<ScreenIngresos> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            'INGRESOS',
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
          crossAxisCount: 2,
          children: <Widget>[
            CardButton(
                icon: const Icon(
                  Icons.add_chart,
                  color: Colors.white,
                  size: 40,
                ),
                title: 'AGREGAR',
                description: 'Agregar un valor al registro de ingresos',
                onTap: () {
                  showModalBottomSheet(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 0.5,
                      context: context,
                      builder: ((context) {
                        return Form(
                            child: Column(
                          children: const [
                            CardTitle(
                                title: ' Agregar Ingreso',
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    label: Text('Concepto del Ingreso')),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    label:
                                        Text('Valor del Ingreso (Guaranies)')),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    label: Text('Descuento (Guaranies)')),
                              ),
                            ),
                          ],
                        ));
                      }));
                }),
            CardButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 40,
                ),
                title: 'ELIMINAR',
                description: 'Eliminar un ingreso del registro',
                onTap: () {
                  Navigator.of(context).pushNamed('IngresosBorrar');
                }),
            CardButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 40,
                ),
                title: 'CORREGIR',
                description: 'Corrige o modifica un ingreso del registro',
                onTap: () {}),
            CardButton(
                icon: const Icon(
                  Icons.visibility,
                  color: Colors.white,
                  size: 40,
                ),
                title: 'CONTROLAR',
                description: 'Despliega la tabla de registro',
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
