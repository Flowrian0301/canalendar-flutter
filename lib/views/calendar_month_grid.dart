import 'package:canalendar/change_notifier_wrapper.dart';
import 'package:canalendar/views/calendar_cell.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CalendarMonthGrid extends StatelessWidget {
  DateTime firstOfMonth;
  Map<DateTime, CalendarCell> cells = {};
  final Function(DateTime date, bool isCurrent) _onDateTapped;
  late DateTime _selectedDate;

  CalendarMonthGrid(this.firstOfMonth, {super.key,
    required ValueNotifier<DateTime> selectedDateNotifier,
    required Function(DateTime date, bool isCurrent) onDateTapped,
    required ChangeNotifierWrapper onSelectedDayDataChangedNotifier})
  : _onDateTapped = onDateTapped {
    firstOfMonth = DateTime(firstOfMonth.year, firstOfMonth.month);
    _selectedDate = selectedDateNotifier.value;
    selectedDateNotifier.addListener(() {
      _updateSelectedDate(selectedDateNotifier.value, oldDate: _selectedDate);
      _selectedDate = selectedDateNotifier.value;
    });
    onSelectedDayDataChangedNotifier.addListener(() => updateSelectedCellDisplay());
  }

  void _updateSelectedDate(DateTime date, {DateTime? oldDate}) {
    //select cell with same day ignoring month
    DateTime selected = DateTime(firstOfMonth.year, firstOfMonth.month, date.day);
    cells[selected]?.setSelected(true);

    if (oldDate == null) return;

    DateTime oldSelected = DateTime(firstOfMonth.year, firstOfMonth.month, oldDate.day);
    cells[oldSelected]?.setSelected(false);
  }

  void updateSelectedCellDisplay() {
    cells[_selectedDate]!.updateData();
  }

  void updateCellDisplays() {
    cells.forEach((key, value) {
      value.updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    cells.clear();
    int firstDayOfWeek = MaterialLocalizations
        .of(context)
        .firstDayOfWeekIndex;
    int visibleDaysOfLastMonth = firstOfMonth.weekday - (firstDayOfWeek) % 7;
    DateTime firstOfLastMonth = Jiffy.parseFromDateTime(firstOfMonth).subtract(months: 1).dateTime;
    DateTime firstOfNextMonth = Jiffy.parseFromDateTime(firstOfMonth).add(months: 1).dateTime;

    int daysInLastMonth = DateTime(firstOfMonth.year, firstOfMonth.month, 0).day;
    int daysInCurrentMonth = DateTime(firstOfNextMonth.year, firstOfNextMonth.month, 0).day;

    bool currentMonth = visibleDaysOfLastMonth == 0;
    int dayIterator = currentMonth ? 1 : daysInLastMonth - visibleDaysOfLastMonth;
    // Create 6 rows
    List<Row> weeks = [];
    DateTime date = DateTime.now();
    for (int week = 0; week < 6; week++) {
      List<Widget> days = [];

      // Create 7 cells
      for (int day = 0; day < 7; day++) {
        date = visibleDaysOfLastMonth > 0
          ? DateTime(firstOfLastMonth.year, firstOfLastMonth.month, dayIterator)
          : (dayIterator <= daysInCurrentMonth && currentMonth
            ? DateTime(firstOfMonth.year, firstOfMonth.month, dayIterator)
            : DateTime(firstOfNextMonth.year, firstOfNextMonth.month, dayIterator));
        date = date.toLocal();

        CalendarCell cell = CalendarCell(
            date,
            (date) => _onDateTapped(date, date.month != firstOfMonth.month),
            isCurrentMonth: date.month == firstOfMonth.month
        );
        days.add(cell);
        cells[date] = cell;
        
        // Add 1 day to iterator
        dayIterator++;

        //handle previous, current and next month jumps
        if (visibleDaysOfLastMonth >= 0) {
          visibleDaysOfLastMonth--;
        }
        if (visibleDaysOfLastMonth == 0) {
          dayIterator = 1;
          currentMonth = true;
        }
        if (currentMonth && dayIterator > daysInCurrentMonth) {
          dayIterator = 1;
          currentMonth = false;
        }
      }
      // Add cells to row
      weeks.add(
        Row(children: days)
      );
    }

    _updateSelectedDate(_selectedDate);
    // Create layout
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 400 ? 400 : constraints
            .maxWidth;
        return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth
            ),
            child: Column(
              children: weeks,
            )
        );
      }
    );
  }
}