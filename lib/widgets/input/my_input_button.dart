import 'package:flutter/material.dart';
import 'package:simple_budget/themes/colors.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final Function()? onDoubleTap;
  final Color? color;
  final double? width;
  final double? padding;
  const MyButton({
    super.key,
    required this.child,
    required this.onTap,
    this.onDoubleTap,
    this.color,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      onDoubleTap: () {
        if (onDoubleTap != null) {
          onDoubleTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.all(padding ?? 10),
        width: (width ?? double.infinity),
        decoration: BoxDecoration(
          color: (color ?? MyColor.primaryColorDark),
          borderRadius: BorderRadius.circular(5),
        ),
        child: child,
      ),
    );
  }
}