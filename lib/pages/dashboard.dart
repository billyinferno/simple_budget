import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final Object id;
  const DashboardPage({
    super.key,
    required this.id,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String _planUid;
  
  @override
  void initState() {
    // get the dashboard id
    _planUid = widget.id as String;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text("Dashboard for $_planUid");
  }
}