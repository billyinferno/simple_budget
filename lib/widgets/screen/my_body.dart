import 'package:flutter/material.dart';

class MyBody extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Widget? overrideWidget;
  const MyBody({
    super.key,
    this.child,
    this.padding,
    this.overrideWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: (overrideWidget ?? Container(
            width: double.infinity,
            padding: (padding ?? const EdgeInsets.fromLTRB(10, 0, 10, 80)),
            child: (child ?? const SizedBox.shrink()),
          )),
        ),
      ],
    );
  }
}