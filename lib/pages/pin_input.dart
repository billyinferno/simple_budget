import 'package:flutter/material.dart';

class PinInputPage extends StatefulWidget {
  final String id;
  const PinInputPage({
    super.key,
    required this.id,
  });

  @override
  State<PinInputPage> createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.id);
  }
}