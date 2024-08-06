import 'package:flutter/material.dart';
import 'package:simple_budget/_index.g.dart';

class MyBottomNavigationItem {
  final Widget icon;
  final Widget text;

  const MyBottomNavigationItem({
    required this.icon,
    required this.text,
  });
}

class MyBottomNavigationBar extends StatefulWidget {
  final int? selectedIndex;
  final Color? selectedColor;
  final List<MyBottomNavigationItem> item;
  final Function(int)? onTap;

  const MyBottomNavigationBar({
    super.key,
    this.selectedIndex,
    this.selectedColor,
    required this.item,
    this.onTap,
  });

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late int _selectedIndex;
  late Color _selectedColor;

  @override
  void initState() {
    // check what is the current selected index
    _selectedIndex = (widget.selectedIndex ?? 0);
    _selectedColor = (widget.selectedColor ?? MyColor.warningColor);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColor.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
          widget.item.length,
          (index) {
            return _item(
              index: index,
              icon: widget.item[index].icon,
              title: widget.item[index].text,
            );  
          },
        ),
      ),
    );
  }

  Widget _selectBar({required Color color}) {
    return Container(
      width: double.infinity,
      height: 10,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _item({
    required int index,
    required Widget icon,
    required Widget? title
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            // ensure that the current index is not the same
            // if the same just cancel the onTap call
            if (_selectedIndex != index) {
              setState(() {              
                widget.onTap!(index + 1);
                _selectedIndex = index;
              });
            }
          }
        },
        child: Container(
          height: 80,
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectBar(color: (index == _selectedIndex ? _selectedColor : Colors.transparent)),
              icon,
              (title != null ? const SizedBox(height: 2,) : const SizedBox.shrink()),
              (title ?? const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}