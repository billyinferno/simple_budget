import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:simple_budget/_index.g.dart';

class MyBotomNavigationBar extends StatefulWidget {
  const MyBotomNavigationBar({super.key});

  @override
  State<MyBotomNavigationBar> createState() => _MyBotomNavigationBarState();
}

class _MyBotomNavigationBarState extends State<MyBotomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColor.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            LucideIcons.user
          ),
          Icon(
            LucideIcons.user
          ),
          Icon(
            LucideIcons.user
          ),
          Icon(
            LucideIcons.user
          ),
          Icon(
            LucideIcons.user
          ),
        ],
      ),
    );
  }
}