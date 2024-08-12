import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:simple_budget/_index.g.dart';

class MyDateUtils {
  static int monthDifference({
    required DateTime startDate,
    required DateTime endDate
  }) {
    // ensure start date is before end date
    assert(startDate.isBefore(endDate));

    // generate the loop date
    DateTime loopDate = DateTime(startDate.year, startDate.month, 1);
    DateTime loopEndDate = DateTime(endDate.year, (endDate.month + 1), 1);
    int monthDiff = 0;

    while(loopDate.isBefore(loopEndDate)) {
      monthDiff = monthDiff + 1;
      loopDate = DateTime(startDate.year, startDate.month + monthDiff, 1);
    }

    return monthDiff;
  }

  static Future<DateTime?> monthPicker({
    required BuildContext context,
    required DateTime initialDate
  }) async {
    DateTime? datePicked;

    await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5, 1),
      lastDate: DateTime(DateTime.now().year + 8, 12),
      initialDate: initialDate,
      confirmWidget: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: MyColor.primaryColor,
          borderRadius: BorderRadius.circular(5)
        ),
        child: const Text(
          "Confirm",
          style: TextStyle(
            color: MyColor.backgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cancelWidget: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: MyColor.backgroundColorDark,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(5)
        ),
        child: const Text(
          "Cancel",
          style: TextStyle(
            color: MyColor.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      monthStylePredicate: (date) {
        return TextButton.styleFrom(
          backgroundColor: MyColor.backgroundColor,
          textStyle: const TextStyle(
            color: MyColor.textColor,
          )
        );
      },
    ).then((value) {
      if (value != null) {
        datePicked = value;
      }
    },);

    return datePicked;
  }
}