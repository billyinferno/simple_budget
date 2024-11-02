import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:simple_budget/_index.g.dart';

class MyMonthCalendar extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Map<DateTime, ContributionStatus> payment;
  final Function(DateTime)? onTap;
  final Function(DateTime)? onDoubleTap;
  const MyMonthCalendar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.payment,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    // get the total month
    int totalMonth = MyDateUtils.monthDifference(
      startDate: DateTime(startDate.year, startDate.month, 1),
      endDate: DateTime(endDate.year, endDate.month, 1),
    );

    // now get how many column we need to generate
    int totalColumn = (totalMonth ~/ 6);
    if ((totalColumn * 6) < totalMonth) {
      totalColumn = totalColumn + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: _generateColumn(
        totalColumn: totalColumn,
        totalMonth: totalMonth
      ),
    );
  }

  List<Widget> _generateColumn({
    required int totalColumn,
    required int totalMonth
  }) {
    List<Widget> returnWidget = [];

    for(int i=0; i<totalColumn; i++) {
      returnWidget.add(
        _rowMonth(
          num: i,
          startDate: DateTime(startDate.year, startDate.month, 1),
          maxNum: totalMonth
        )
      );
    }

    return returnWidget;
  }

  Widget _rowMonth({
    required int num,
    required DateTime startDate,
    required int maxNum,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List<Widget>.generate(6, (index) {
        int calcNum = ((num * 6) + index);
        
        // check if calcNum is more than the total month or not?
        if (calcNum > (maxNum - 1)) {
          return const Expanded(child: SizedBox.shrink());
        }

        // calcNum is below total month, so we can calculate the date
        DateTime calcDate = DateTime(
          startDate.year,
          startDate.month + calcNum,
          1
        );

        // generate the item month
        return _itemMonth(
          date: calcDate,
          paid: (payment[calcDate] ?? ContributionStatus.none)
        );
      },),
    );
  }

  Widget _itemMonth({
    required DateTime date,
    required ContributionStatus paid
  }) {
    Icon currentIcon;

    // check if already paid or not whether this is in future or not?
    if (paid == ContributionStatus.full) {
      currentIcon = const Icon(
        LucideIcons.check,
        color: MyColor.primaryColor,
      );
    }
    else {
      // check if the date is more than today date?
      if (date.isAfter(DateTime.now())) {
        // check if got partial payment or not?
        if (paid == ContributionStatus.partial) {
          currentIcon = const Icon(
            LucideIcons.ungroup,
            color: MyColor.warningColor,
          );
        }
        else {
          currentIcon = const Icon(
            LucideIcons.minus,
            color: MyColor.backgroundColorDark,
          );
        }
      }
      else {  
        currentIcon = const Icon(
          LucideIcons.x,
          color: MyColor.errorColor,
        );
      }
    }

    // check
    return Expanded(
      child: InkWell(
        highlightColor: MyColor.backgroundColorDark,
        onTap: (() {
          if (onTap != null) {
            onTap!(date);
          }
        }),
        onDoubleTap: (() {
          if (onDoubleTap != null) {
            onDoubleTap!(date);
          }
        }),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border.all(
              color: Colors.grey[800]!,
              style: BorderStyle.solid,
              width: 1.0,
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                Globals.dfMon.format(date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Globals.dfyy.format(date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              currentIcon,
            ],
          ),
        ),
      ),
    );
  }
}