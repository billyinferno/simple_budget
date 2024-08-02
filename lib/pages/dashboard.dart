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
  late String _dashboardId;
  
  @override
  void initState() {
    // get the dashboard id
    _dashboardId = widget.id as String;
    // TODO: remove once we create the page
    debugPrint("Dashboard ID: $_dashboardId");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Dashboard");
  }
}