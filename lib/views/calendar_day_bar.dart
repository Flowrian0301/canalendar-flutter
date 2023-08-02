import 'package:canalendar/utils/string_util.dart';
import 'package:flutter/material.dart';

class CalendarDayBar extends StatefulWidget {
  final ValueNotifier<DateTime> _date = ValueNotifier(DateTime.now());

  CalendarDayBar({super.key});

  void setSelectedDate(DateTime date) => _date.value = date;

  @override
  State<StatefulWidget> createState() => _CalendarDayBarState();

}

class _CalendarDayBarState extends State<CalendarDayBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<DateTime>(
            valueListenable: widget._date,
            builder: (context, date, child) {
              return Container(
                color: const Color.fromRGBO(240, 240, 240, 1),
                child: Text(StringUtil.getPositionalDayData(context, date)),
              );
            }
          )
        )
      ]
    );
  }

}