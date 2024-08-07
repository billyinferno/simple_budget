import 'package:flutter/material.dart';

class PlanItemPage extends StatefulWidget {
  final Object? date;
  const PlanItemPage({
    super.key,
    required this.date,
  });

  @override
  State<PlanItemPage> createState() => _PlanItemPageState();
}

class _PlanItemPageState extends State<PlanItemPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}