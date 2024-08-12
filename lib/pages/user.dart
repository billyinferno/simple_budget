import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "User",
            style: TextStyle(
              color: MyColor.backgroundColor,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.go('/dashboard');
          },
          icon: const Icon(
            LucideIcons.chevron_left,
            color: MyColor.backgroundColor,
          )
        ),
      ),
      body: const Center(
        child: Text("Coming soon"),
      ),
    );
  }
}