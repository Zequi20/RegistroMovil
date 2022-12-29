import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  const CardButton(
      {super.key,
      required this.icon,
      required this.title,
      required this.description,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation: 10,
          color: Colors.indigo.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ));
  }
}

class CardTitle extends StatelessWidget {
  final String title;
  final Icon icon;
  const CardTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      elevation: 10,
      color: Colors.indigo.shade900,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
