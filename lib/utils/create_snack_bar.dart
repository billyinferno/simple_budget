import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:simple_budget/themes/colors.dart';

SnackBar createSnackBar({required String message, Icon? icon, int? duration}) {
  Icon snackBarIcon = (icon ?? const Icon(LucideIcons.message_circle_warning, size: 20, color: MyColor.errorColor,));
  int animationDuration = (duration ?? 3);

  SnackBar snackBar = SnackBar(
    duration: Duration(seconds: animationDuration),
    backgroundColor: MyColor.primaryColorDark,
    content: SizedBox(
      height: 25,
      child: Row(
        children: <Widget>[
          snackBarIcon,
          const SizedBox(width: 10,),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: '--apple-system'
            ),
          ),
        ],
      ),
    ),
  );

  return snackBar;
}