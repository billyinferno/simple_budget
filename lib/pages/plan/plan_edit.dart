import 'package:flutter/material.dart';
import 'package:simple_budget/_index.g.dart';

class PlanEditPage extends StatefulWidget {
  final Object? uid;
  const PlanEditPage({
    super.key,
    required this.uid,
  });

  @override
  State<PlanEditPage> createState() => _PlanEditPageState();
}

class _PlanEditPageState extends State<PlanEditPage> {
  late String _planUID;

  @override
  void initState() {
    _planUID = (widget.uid ?? '') as String;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        foregroundColor: Colors.white,
        title: Center(child: Text("Edit Plan $_planUID"),),
      ),
      body: const Placeholder(),
    );
  }
}