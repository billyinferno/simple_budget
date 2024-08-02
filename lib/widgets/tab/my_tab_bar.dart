import 'package:flutter/material.dart';
import 'package:simple_budget/themes/colors.dart';

class MyTabBar extends StatefulWidget {
  final Map<String, String> tab;
  final String? initialTab;
  final Function(String) onTap;
  const MyTabBar({
    super.key,
    required this.tab,
    this.initialTab,
    required this.onTap,
  });

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  late String _currentTab;

  @override
  void initState() {
    _currentTab = (widget.initialTab ?? '');
    if (_currentTab.isEmpty && widget.tab.isNotEmpty) {
      // use the first key as _currentTab
      _currentTab = widget.tab.keys.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // check if tab data is empty or not?
    if (widget.tab.isEmpty) {
      return const SizedBox.shrink();
    }

    // generate the tab
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _generateTab(),
    );
  }

  List<Widget> _generateTab() {
    List<Widget> ret = [];

    // loop thru the map
    for(String key in widget.tab.keys) {
      ret.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.onTap(key);
                _currentTab = key;
              });
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                color: (key == _currentTab ? MyColor.primaryColor : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                widget.tab[key] ?? '',
                style: TextStyle(
                  color: (key == _currentTab ? Colors.white : MyColor.textColor),
                  fontWeight: (key == _currentTab ? FontWeight.bold : FontWeight.normal),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      );
    }

    return ret;
  }
}