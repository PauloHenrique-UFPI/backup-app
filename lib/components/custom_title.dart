import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final Color color;
  final String fontFamily;

  CustomTitle({
    required this.text,
    this.color = Colors.orange,
    this.fontFamily = 'Roboto',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 25,
          color: color,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
