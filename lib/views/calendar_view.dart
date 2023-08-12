import 'package:canalendar/utils/string_util.dart';
import 'package:canalendar/views/calendar_day_bar.dart';
import 'package:canalendar/views/calendar_header.dart';
import 'package:canalendar/views/calendar_month_grid.dart';
import 'package:canalendar/views/day_amounts.dart';
import 'package:flutter/material.dart';

import '../models/amounts.dart';
import '../models/persistency/save_data.dart';
import 'month_amounts.dart';

class CalendarView extends StatelessWidget {
  static DateTime selectedDate = DateTime.now();
  DateTime _firstOfMonth = DateTime.now();
  CalendarMonthGrid? monthGrid;
  Function(DateTime date)? _onSelectedDateSet;
  Function(DateTime date)? onDateSelected;
  CalendarDayBar dayBar = CalendarDayBar();
  MonthAmounts monthAmountsView = MonthAmounts();
  DayAmounts dayAmountsView = DayAmounts();

  CalendarView({super.key, this.onDateSelected}) {
    _firstOfMonth = DateTime(_firstOfMonth.year, _firstOfMonth.month);
    DateTime selectedDate = DateTime(
        CalendarView.selectedDate.year,
        CalendarView.selectedDate.month,
        CalendarView.selectedDate.day
    );

    monthGrid = CalendarMonthGrid((date) => _selectDate(date));

    _onSelectedDateSet = (date) {
      dayBar.setSelectedDate(date);
      _updateMonthAmountsView();
      _updateDayAmountsView();
    };

    _selectDate(selectedDate);
  }

  void updateSelectedDay() {
    monthGrid!.updateSelectedCell();
    _updateDayAmountsView();
  }

  void onUserChanged() {
    monthGrid!.updateCells();
    _updateMonthAmountsView();
    _updateDayAmountsView();
  }

  void _updateDayAmountsView() {
    Amounts dayAmounts = SaveData.currentUser.value == null
        ? Amounts()
        : Amounts.fromSessions(SaveData.currentUser.value!.getSessions(selectedDate));
    dayAmountsView.setAmounts(dayAmounts);
  }

  void _updateMonthAmountsView() {
    Amounts monthAmounts = SaveData.currentUser.value == null
        ? Amounts()
        : Amounts.fromSessions(SaveData.currentUser.value!.getMonthSessions(selectedDate));
    monthAmountsView.setAmounts(monthAmounts);
  }

  void _selectDate(DateTime date) {
    monthGrid?.updateSelectedDate(date, oldDate: CalendarView.selectedDate);
    CalendarView.selectedDate = date;
    _onSelectedDateSet!(CalendarView.selectedDate);
    if (onDateSelected != null) onDateSelected!(CalendarView.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(StringUtil.getMonthYear(context, _firstOfMonth)),
                monthAmountsView,
              ],
            ),
          ),
        ),
        const CalendarHeader(),
        Expanded(child:
        SingleChildScrollView(
          child: Column(
            children: [
              monthGrid!,
              dayBar,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: dayAmountsView,
                    )
                  )
                ],
              )
            ],
          ),
        )
        )
      ],
    );
  }
}