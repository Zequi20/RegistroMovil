import 'package:flutter/material.dart';
import 'widgets/my_widgets.dart';

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
                  Navigator.of(context).pushNamed('IngresosAgregar');
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
