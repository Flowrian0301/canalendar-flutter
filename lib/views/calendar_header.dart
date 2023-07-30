import 'package:canalendar/utils/string_util.dart';
import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // localized first day of week (computed to fit the order of DateTime.dayOfWeek)
    int firstDayOfWeek = (MaterialLocalizations
        .of(context)
        .firstDayOfWeekIndex);
    DateTime date = DateTime.now();
    date = date.add(Duration(days: firstDayOfWeek - date.weekday));
    Duration addDay = const Duration(days: 1);

    List<Expanded> children = [];
    for (int i = 0; i < 7; i++) {
      children.add(
        Expanded(
          child: Text(
            StringUtil.localizedDayNameShort(context, date),
            textAlign: TextAlign.center,
          )
        )
      );
      date = date.add(addDay);
    }
    return LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth > 400 ? 400 : constraints
              .maxWidth;
          return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: Row(children: children)
          );
        }
    );
  }

}
