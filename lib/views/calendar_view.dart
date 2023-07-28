import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  DateTime firstOfMonth = DateTime.now();

  CalendarView({super.key}) {
    DateTime now = DateTime.now();
    firstOfMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    DateTime counter = firstOfMonth;
    int firstDayOfWeek = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    counter = counter.subtract(Duration(days: (counter.weekday + firstDayOfWeek - 1) % 7));

    Duration add = const Duration(days: 1);
    List<Row> rows = [];
    for (int week = 0; week < 6; week++) {
      List<Expanded> days = [];
      for (int day = 0; day < 7; day++) {
        days.add(Expanded(child:
            AspectRatio(
              aspectRatio: 1,
              child: Text(counter.day.toString())
            )
        ));
        counter = counter.add(add);
      }
      rows.add(Row(
        children: days,
      ));
    }
    return Align(
      child: Wrap(
        children: rows,
      )
    );
  }

}