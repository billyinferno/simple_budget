import 'package:flutter/material.dart';
import 'package:simple_budget/_index.g.dart';

class PlanAddPage extends StatefulWidget {
  const PlanAddPage({super.key});

  @override
  State<PlanAddPage> createState() => _PlanAddPageState();
}

class _PlanAddPageState extends State<PlanAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Add Plan",
            style: TextStyle(
              color: MyColor.backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}