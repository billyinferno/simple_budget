import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:simple_budget/_index.g.dart';

class MyParticpatList extends StatelessWidget {
  final String name;
  final EditType? edit;
  final Function() onDelete;
  const MyParticpatList({
    super.key,
    required this.name,
    required this.onDelete,
    this.edit,
  });

  @override
  Widget build(BuildContext context) {
    // check if edit is not null?
    Color color = MyColor.textColor;
    Icon userIcon = const Icon(
      LucideIcons.user_minus,
      color: MyColor.errorColor,
      size: 14,
    );

    if (edit != null) {
      // change the color based on the edit type
      if (edit == EditType.add) {
        color = MyColor.primaryColorDark;
      }
      else if (edit == EditType.delete) {
        color = MyColor.errorColor;
        userIcon = const Icon(
          LucideIcons.user_plus,
          color: MyColor.primaryColorDark,
          size: 14,
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          LucideIcons.user,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 10,),
        IconButton(
          onPressed: (() {
            onDelete();
          }),
          icon: userIcon
        ),
      ],
    );
  }
}