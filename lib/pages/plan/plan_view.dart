import 'package:flutter/material.dart';

class PlanViewPage extends StatefulWidget {
  final Object uid;
  const PlanViewPage({
    super.key,
    required this.uid,
  });

  @override
  State<PlanViewPage> createState() => _PlanViewPageState();
}

class _PlanViewPageState extends State<PlanViewPage> {
  late String _planUid;

  @override
  void initState() {
    // get the dashboard UID
    _planUid = widget.uid as String;
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}