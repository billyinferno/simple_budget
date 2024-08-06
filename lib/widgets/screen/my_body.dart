import 'package:flutter/material.dart';

class MyBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const MyBody({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: (padding ?? const EdgeInsets.fromLTRB(10, 0, 10, 80)),
      child: child,
    );
  }
}