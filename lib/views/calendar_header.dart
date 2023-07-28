import 'package:canalendar/utils/string_util.dart';
import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    List<Expanded> childs = [];
    for (int i = 0; i < 7; i++) {
      childs.add(Expanded(child: Text(StringUtil.localizedDayName(i))));
    }
    return Row(children: childs);
  }
}
