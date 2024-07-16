import 'package:flutter/material.dart';

class TextoBf extends StatelessWidget {
  final String label;

  TextoBf(
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
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}