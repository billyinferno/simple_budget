import 'package:flutter/material.dart';
import 'package:simple_budget/_index.g.dart';

class MyBarChart extends StatelessWidget {
  final double? height;
  final int value;
  final int maxValue;
  final List<Color>? colors;
  final Color bgColor;
  final Color fgColor;
  final String text;

  const MyBarChart({
    super.key,
    this.height,
    required this.value,
    required this.maxValue,
    this.colors,
    this.bgColor = MyColor.backgroundColorDark,
    this.fgColor = MyColor.textColor,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (height ?? 25),
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: (value),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: (colors ?? [
                        MyColor.errorColor,
                        MyColor.warningColor,
                        MyColor.successColor,
                      ]),
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
              Expanded(
                flex: (maxValue - value),
                child: const SizedBox(),
              ),
            ],
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: fgColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}