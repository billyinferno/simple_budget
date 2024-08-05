import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';

class PageNotFound extends StatefulWidget {
  final String title;
  final String message;
  const PageNotFound({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  State<PageNotFound> createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() {
            // go to login page, we will handle the route there
            context.go('/login');
          }),
          icon: const Icon(
            LucideIcons.arrow_left,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: MyColor.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyColor.primaryColorDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MyColor.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        LucideIcons.message_circle_warning,
                        color: MyColor.errorColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20,),
                MyButton(
                  color: MyColor.errorColor,
                  onTap: (() {
                    context.go('/login');
                  }),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        LucideIcons.arrow_left,
                        size: 12,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Back to Main Menu",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}