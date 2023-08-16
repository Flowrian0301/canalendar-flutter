import 'dart:io';

import 'package:canalendar/change_notifier_wrapper.dart';
import 'package:canalendar/custom_scroll_physics.dart';
import 'package:canalendar/views/calendar_month_grid.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CalendarCarousel extends StatefulWidget {
  final Function(DateTime date, bool isScrolling) _onSelectedDateSet;
  DateTime currentMonthDate = DateTime.now();
  ValueNotifier<DateTime> _selectedDateNotifier;
  ChangeNotifierWrapper _onSelectedDayDataChangedNotifier;

  CalendarCarousel({super.key,
    required Function(DateTime date, bool isScrolling) onSelectedDateSet,
    required ValueNotifier<DateTime> selectedDateNotifier,
    required ChangeNotifierWrapper onSelectedDayDataChangedNotifier
  }) : _onSelectedDateSet = onSelectedDateSet,
      _selectedDateNotifier = selectedDateNotifier,
      _onSelectedDayDataChangedNotifier = onSelectedDayDataChangedNotifier
  {
    currentMonthDate = DateTime(currentMonthDate.year, currentMonthDate.month);
  }

  @override
  CalendarCarouselState createState() => CalendarCarouselState();
}

class CalendarCarouselState extends State<CalendarCarousel> {
  PageController _pageController = PageController(initialPage: 1);
  List<CalendarMonthGrid> _monthGrids = [];
  DateTime? _pendingDate;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page == _pageController.page!.roundToDouble()) {
      int nextPage = _pageController.page!.toInt();
      if (_isWholeNumber(_pageController.page!) && _pageController.page! != 1) {
        setState(() {
          _pendingDate ??= Jiffy.parseFromDateTime(widget._selectedDateNotifier.value).add(months: nextPage - 1).dateTime;
          widget._onSelectedDateSet(_pendingDate!, false);
          widget.currentMonthDate = Jiffy.parseFromDateTime(widget.currentMonthDate).add(months: nextPage - 1).dateTime;
          _pendingDate = null;
          _pageController.jumpToPage(1);
        });
      }
    }
  }

  void scrollToPrevious({DateTime? pendingDate}) {
    _pageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    _pendingDate = pendingDate;
  }

  void scrollToNext({DateTime? pendingDate}) {
    _pageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    _pendingDate = pendingDate;
  }

  @override
  Widget build(BuildContext context) {
    _monthGrids.clear();
    ExpandablePageView pageView = ExpandablePageView.builder(
      physics: defaultTargetPlatform == TargetPlatform.android
          || defaultTargetPlatform == TargetPlatform.iOS
          ? CustomPageScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemCount: 3,
      pageSnapping: false,
      itemBuilder: (context, index) {
        DateTime currentDate = Jiffy.parseFromDateTime(widget.currentMonthDate).add(months: index - 1).dateTime;
        CalendarMonthGrid month = CalendarMonthGrid(
            currentDate,
            onDateTapped: (date, isCurrent) {
              int newMonth = date.month;
              int oldMonth = widget._selectedDateNotifier.value.month;
              if (newMonth > oldMonth) {
                scrollToNext(pendingDate: date);
              } else if (newMonth < oldMonth) {
                scrollToPrevious(pendingDate: date);
              }
              else {
                widget._onSelectedDateSet(date, newMonth != oldMonth);
              }
            },
            selectedDateNotifier: widget._selectedDateNotifier,
            onSelectedDayDataChangedNotifier: widget._onSelectedDayDataChangedNotifier,
        );
        _monthGrids.add(month);
        return month;
      },
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 400 ? 400 : constraints.maxWidth;
        return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: pageView
        );
      }
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static bool _isWholeNumber(double value) {
    return value.toInt().toDouble() == value;
  }
}