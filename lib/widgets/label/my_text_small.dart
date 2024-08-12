import 'package:flutter/material.dart';
import 'package:simple_budget/_index.g.dart';

class TextSmall extends StatelessWidget {
  final String text;
  final Color? color;
  const TextSmall({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: (color ?? MyColor.primaryColorDark),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}