import 'package:flutter/material.dart';

class TextoCampo extends StatelessWidget {
  final String label;

  TextoCampo(
      {Key? key,
      required this.label,
     })
      : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }
}