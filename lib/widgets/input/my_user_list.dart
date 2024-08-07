import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_budget/_index.g.dart';

class MyUserList extends StatelessWidget {
  final String uid;
  final DateTime date;
  final String name;
  final bool paid;
  final Function() onAdd;
  final Function() onRemove;
  final bool? enableSlide;
  const MyUserList({
    super.key,
    required this.uid,
    required this.date,
    required this.name,
    required this.paid,
    required this.onAdd,
    required this.onRemove,
    this.enableSlide,
  });

  @override
  Widget build(BuildContext context) {
    if (enableSlide ?? true) {
      return Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: <Widget>[
            SlidableAction(
              onPressed: (context) async {
                onAdd();
              },
              icon: LucideIcons.plus,
              backgroundColor: MyColor.primaryColorDark,
              foregroundColor: MyColor.backgroundColorDark,
            ),
            SlidableAction(
              onPressed: (context) {
                onRemove();
              },
              icon: LucideIcons.minus,
              backgroundColor: MyColor.errorColor,
              foregroundColor: MyColor.backgroundColorDark,
            ),
          ]
        ),
        child: _userItem(),
      );
    }
    else {
      // if slide is not enabled then just return the user item
      return _userItem();
    }
  }

  Widget _userItem() {
    Icon paidIcon = const Icon(
      LucideIcons.check,
      size: 24,
      color: MyColor.primaryColorDark,
    );

    // check if user already paid for contribution or not?
    if (!paid) {
      paidIcon = const Icon(
        LucideIcons.x,
        size: 24,
        color: MyColor.errorColor,
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyColor.backgroundColorDark,
            width: 1.0,
            style: BorderStyle.solid,
          )
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Icon(
            LucideIcons.circle_user_round,
            size: 24,
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Text(
              (name).toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          paidIcon,
          const SizedBox(width: 10,)
        ],
      ),
    );
  }
}