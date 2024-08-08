import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_budget/_index.g.dart';

class MyDialog {
  static Future<void> showAlert({
    required BuildContext context,
    String? title,
    required String text,
    String? okayLabel,
    Color? okayColor,
  }) async {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(190),
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title ?? "Information",
            style: const TextStyle(
              fontFamily: '--apple-system',
            ),
          ),
          content: Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: '--apple-system',
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: (() {
                Navigator.pop(context);
              }),
              child: Text(
                okayLabel ?? "Okay",
                style: TextStyle(
                  fontFamily: '--apple-system',
                  color: (okayColor ?? MyColor.textColor)
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showConfirmation({
    required BuildContext context,
    String? title,
    required String text,
    String? okayLabel,
    Color? okayColor,
    String? cancelLabel,
    Color? cancelColor,
  }) async {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(190),
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title ?? "Confirmation",
            style: const TextStyle(
              fontFamily: '--apple-system',
            ),
          ),
          content: Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: '--apple-system',
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: (() {
                Navigator.pop(context, true);
              }),
              child: Text(
                okayLabel ?? "Confirm",
                style: TextStyle(
                  fontFamily: '--apple-system',
                  color: (okayColor ?? MyColor.textColor)
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: (() {
                Navigator.pop(context, false);
              }),
              child: Text(
                cancelLabel ?? "Cancel",
                style: TextStyle(
                  fontFamily: '--apple-system',
                  color: (cancelColor ?? MyColor.textColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}