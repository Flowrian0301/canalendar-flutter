import 'dart:io';

import 'package:canalendar/change_notifier_wrapper.dart';
import 'package:canalendar/utils/string_util.dart';
import 'package:canalendar/views/calendar_carousel.dart';
import 'package:canalendar/views/calendar_day_bar.dart';
import 'package:canalendar/views/calendar_header.dart';
import 'package:canalendar/views/day_amounts.dart';
import 'package:canalendar/views/month_amounts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:canalendar/models/amounts.dart';
import 'package:canalendar/models/persistency/save_data.dart';

class CalendarView extends StatelessWidget {
  static ValueNotifier<bool> lineDisplay = ValueNotifier(false);
  ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  DateTime _firstOfMonth = DateTime.now();
  Function(DateTime date)? _onSelectedDateSet;
  Function(DateTime date)? onDateSelected;
  CalendarDayBar dayBar = CalendarDayBar();
  MonthAmounts monthAmountsView = MonthAmounts();
  DayAmounts dayAmountsView = DayAmounts();
  final ChangeNotifierWrapper _onSelectedDayDataChangedNotifier = ChangeNotifierWrapper();
  final GlobalKey<CalendarCarouselState> _carouselKey = GlobalKey();

  CalendarView({super.key, this.onDateSelected}) {
    _firstOfMonth = DateTime(_firstOfMonth.year, _firstOfMonth.month);
    DateTime selectedDate = DateTime(
        this.selectedDate.value.year,
        this.selectedDate.value.month,
        this.selectedDate.value.day
    );

    //monthGrid = CalendarMonthGrid((date) => _selectDate(date), _firstOfMonth);

    _onSelectedDateSet = (date) {
      dayBar.setSelectedDate(date);
      updateMonthAmounts();
      _updateSelectedDayAmounts();
    };

    _selectDate(selectedDate);
  }

  void updateDayDisplays() {
    _onSelectedDayDataChangedNotifier.notify();
    _updateSelectedDayAmounts();
  }

  void onUserChanged() {
    //monthGrid!.updateCells();
    updateMonthAmounts();
    _updateSelectedDayAmounts();
  }

  void _updateSelectedDayAmounts() {
    Amounts dayAmounts = SaveData.currentUser.value == null
        ? Amounts()
        : Amounts.fromSessions(SaveData.currentUser.value!.getSessions(selectedDate.value));
    dayAmountsView.setAmounts(dayAmounts);
  }

  void updateMonthAmounts() {
    Amounts monthAmounts = SaveData.currentUser.value == null
        ? Amounts()
        : Amounts.fromSessions(SaveData.currentUser.value!.getMonthSessions(selectedDate.value));
    monthAmountsView.setAmounts(monthAmounts);
  }

  void _selectDate(DateTime date) {
    //_carouselKey.currentState?.updateSelectedDate(date, oldDate: CalendarView.selectedDate.value);
    /*int newMonth = date.month;
    int oldMonth = selectedDate.value.month;
    if (newMonth > oldMonth) {
      _carouselKey.currentState?.scrollToNext();
    } else if (newMonth < oldMonth) {
      _carouselKey.currentState?.scrollToPrevious();
    }*/
    selectedDate.value = date;
    _onSelectedDateSet!(selectedDate.value);
    if (onDateSelected != null) onDateSelected!(selectedDate.value);
  }

  @override
  Widget build(BuildContext context) {
    CalendarCarousel carousel = CalendarCarousel(
      key: _carouselKey,
      onSelectedDateSet: (date, isScrolling) => _selectDate(date),
      selectedDateNotifier: selectedDate,
      onSelectedDayDataChangedNotifier: _onSelectedDayDataChangedNotifier,
    );

    Widget header = InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: selectedDate,
              builder: (context, date, child) {
                return Text(StringUtil.getMonthYear(context, date));
              }
          ),
          monthAmountsView,
        ],
      ),
    );

    bool useBtnsInHeader = kIsWeb ? true
        : !(defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

    Widget platformSpecificHeader = useBtnsInHeader
    ? LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth > 400 ? 400 : constraints
              .maxWidth;
          return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => _carouselKey.currentState?.scrollToPrevious(),
                      icon: Icon(
                          defaultTargetPlatform == TargetPlatform.windows
                              ? Icons.arrow_back
                              : Icons.arrow_back_ios
                      )
                  ),
                  Expanded(
                      child: header
                  ),
                  IconButton(
                      onPressed: () => _carouselKey.currentState?.scrollToNext(),
                      icon: Icon(
                          defaultTargetPlatform == TargetPlatform.windows
                              ? Icons.arrow_forward
                              : Icons.arrow_forward_ios
                      )
                  )
                ],
              )
          );
        }
    )
    : header;
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: platformSpecificHeader
        ),
        const CalendarHeader(),
        Expanded(child:
        SingleChildScrollView(
          child: Column(
            children: [
              carousel,
              const SizedBox(
                height: 8,
              ),
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