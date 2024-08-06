import 'package:flutter/material.dart';
import 'package:simple_budget/_index.g.dart';

class MyIconLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final bool? addPadding;
  const MyIconLabel({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.addPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ((addPadding ?? false) ? const EdgeInsets.fromLTRB(0, 0, 10, 0) : const EdgeInsets.all(0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: (color ?? MyColor.textColor),
            size: 14,
          ),
          const SizedBox(width: 5,),
          Text(
            text,
            style: TextStyle(
              color: (color ?? MyColor.textColor),
            ),
          )
        ],
      ),
    );
  }
}