import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';
import 'package:simple_budget/widgets/input/my_bottom_navigation_bar.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Plan View",
            style: TextStyle(
              color: MyColor.backgroundColor,
            ),
          ),
        ),
        actions: _actionAppBar(),
      ),
      bottomNavigationBar: MyBotomNavigationBar(),
    );
  }

  List<Widget> _actionAppBar() {
    List<Widget> ret = [];

    //TODO: to check if user logon or not here, if logon then we can show the user menu
    ret.add(
      IconButton(
        onPressed: (() {
          context.go('/user');
        }),
        icon: const Icon(
          LucideIcons.user,
          color: MyColor.backgroundColor,
        )
      )
    );

    ret.add(const SizedBox(width: 10,));

    return ret;
  }
}