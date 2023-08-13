import 'package:canalendar/views/calendar_month_grid.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CalendarCarousel extends StatefulWidget {
  final Function(DateTime date) _onSelectedDateSet;
  DateTime currentMonthDate = DateTime.now();
  ValueNotifier<DateTime> _selectedDateNotifier;

  CalendarCarousel({super.key, required Function(DateTime date) onSelectedDateSet, required ValueNotifier<DateTime> selectedDateNotifier})
  : _onSelectedDateSet = onSelectedDateSet, _selectedDateNotifier = selectedDateNotifier {
    currentMonthDate = DateTime(currentMonthDate.year, currentMonthDate.month);
  }

  @override
  CalendarCarouselState createState() => CalendarCarouselState();
}

class CalendarCarouselState extends State<CalendarCarousel> {
  PageController _pageController = PageController(initialPage: 1);
  List<CalendarMonthGrid> _monthGrids = [];

  /*void updateSelectedDate(DateTime date, {DateTime? oldDate}) {
    for (CalendarMonthGrid monthGrid in _monthGrids) {
      monthGrid.updateSelectedDate(date, oldDate: oldDate);
    }
  }

  void updateSelectedCell() {
    for (CalendarMonthGrid monthGrid in _monthGrids) {
      monthGrid.updateSelectedCell();
    }
  }*/

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
          widget._onSelectedDateSet(Jiffy.parseFromDateTime(widget._selectedDateNotifier.value).add(months: nextPage - 1).dateTime);
          widget.currentMonthDate = Jiffy.parseFromDateTime(widget.currentMonthDate).add(months: nextPage - 1).dateTime;
          _pageController.jumpToPage(1);
          print("object");
        });
      }
    }
  }

  void scrollToPrevious() {
    _pageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void scrollToNext() {
    _pageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    _monthGrids.clear();
    ExpandablePageView pageView = ExpandablePageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemCount: 3,
      itemBuilder: (context, index) {
        DateTime currentDate = Jiffy.parseFromDateTime(widget.currentMonthDate).add(months: index - 1).dateTime;
        CalendarMonthGrid month = CalendarMonthGrid(widget._onSelectedDateSet, currentDate, selectedDateNotifier: widget._selectedDateNotifier);
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