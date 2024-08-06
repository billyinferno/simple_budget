import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';

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
  late List<MyBottomNavigationItem> _item;

  @override
  void initState() {
    // get the dashboard UID
    _planUid = widget.uid as String;

    //TODO: bottom bar shouldn't be here this is just to mock up
    _item = [
      const MyBottomNavigationItem(
        icon: Icon(
          LucideIcons.user,
          color: Colors.white,
        ),
        text: Text(
          "Test",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      const MyBottomNavigationItem(
        icon: Icon(
          LucideIcons.user,
          color: Colors.white,
        ),
        text: Text("Test")
      ),
      const MyBottomNavigationItem(
        icon: Icon(
          LucideIcons.user,
          color: Colors.white,
        ),
        text: Text("Test")
      ),
      const MyBottomNavigationItem(
        icon: Icon(
          LucideIcons.user,
          color: Colors.white,
        ),
        text: Text("Test")
      ),
    ];
    
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
      bottomNavigationBar: MyBottomNavigationBar(
        item: _item,
        onTap: (value) {
          debugPrint("Value clicked $value");
        },
      ),
      body: MyBody(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10,),
              Text(
                "ID: $_planUid",
                style: const TextStyle(
                  color: MyColor.textColorSecondary
                ),
              ),
              Text(
                ("Plan Goes to Korea").toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MyIconLabel(icon: LucideIcons.user, text: "3"),
                  MyIconLabel(icon: LucideIcons.dollar_sign, text: "36M (80%)"),
                  MyIconLabel(icon: LucideIcons.calendar, text: "07/24 - 07/25", addPadding: false,),
                ],
              ),
              const SizedBox(height: 10,),
              Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
            ],
          ),
        )
      ),
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