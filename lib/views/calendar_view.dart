import 'package:canalendar/utils/string_util.dart';
import 'package:canalendar/views/calendar_day_bar.dart';
import 'package:canalendar/views/calendar_header.dart';
import 'package:canalendar/views/calendar_month_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarView extends StatefulWidget {

  CalendarView({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _firstOfMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();
  CalendarMonthGrid? monthGrid;
  Function(DateTime date)? _onSelectedDateSet;

  _CalendarViewState() {
    _firstOfMonth = DateTime(_firstOfMonth.year, _firstOfMonth.month);
    selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    monthGrid = CalendarMonthGrid((date) => _selectDate(date));
  }

  void _selectDate(DateTime date) {
    monthGrid?.updateSelectedDate(date, oldDate: selectedDate);
    selectedDate = date;
    _onSelectedDateSet!(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    CalendarDayBar dayBar = CalendarDayBar();
    _onSelectedDateSet = (date) => dayBar.setSelectedDate(date);

    return Column(
      children: <Widget>[
        Text(StringUtil.getMonthYear(context, _firstOfMonth)),
        const CalendarHeader(),
        Expanded(child:
        SingleChildScrollView(
          child: Column(
            children: [
              monthGrid!,
              dayBar
            ],
          ),
        )
        )
      ],
    );
  }

}