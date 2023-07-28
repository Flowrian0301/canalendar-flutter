import 'package:canalendar/utils/string_util.dart';
import 'package:flutter/material.dart';

class CalendarDayBar extends StatelessWidget {
  Text _label = Text('Today');

  CalendarDayBar({super.key}) {
    _label.data = StringUtil.positionalDayData(DateTime.now());
  }



  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Te
    ]);
  }

}