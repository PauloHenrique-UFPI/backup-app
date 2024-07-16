import 'package:flutter/material.dart';

class TituloTexto extends StatelessWidget {
  final String label;

  TituloTexto(
      {Key? key,
      required this.label,
     })
      : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10.0), 
        border: Border.all(
          color: const Color.fromARGB(255, 15, 15, 15), 
          width: 2.0, 
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}