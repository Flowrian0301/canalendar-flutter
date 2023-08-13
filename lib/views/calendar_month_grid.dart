import 'package:canalendar/views/calendar_cell.dart';
import 'package:canalendar/views/calendar_view.dart';
import 'package:flutter/material.dart';

class CalendarMonthGrid extends StatelessWidget {
  DateTime firstOfMonth;
  Map<DateTime, CalendarCell> cells = {};
  final Function(DateTime date) _onSelectedDateSet;
  late DateTime _selectedDate;

  CalendarMonthGrid(this._onSelectedDateSet, this.firstOfMonth, {super.key, required ValueNotifier<DateTime> selectedDateNotifier}) {
    _selectedDate = selectedDateNotifier.value;
    selectedDateNotifier.addListener(() {
      _updateSelectedDate(selectedDateNotifier.value, oldDate: _selectedDate);
      _selectedDate = selectedDateNotifier.value;
    });
  }

  void _updateSelectedDate(DateTime date, {DateTime? oldDate}) {
    //select cell with same day ignoring month
    DateTime selected = DateTime(firstOfMonth.year, firstOfMonth.month, date.day);
    cells[selected]?.setSelected(true);

    if (oldDate == null) return;

    DateTime oldSelected = DateTime(firstOfMonth.year, firstOfMonth.month, oldDate.day);
    cells[oldSelected]?.setSelected(false);
  }

  void updateSelectedCell() {
    cells[_selectedDate]!.updateData();
  }

  void updateCells() {
    cells.forEach((key, value) {
      value.updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    cells.clear();

    // Date iterator
    DateTime dateIterator = firstOfMonth;
    int firstDayOfWeek = MaterialLocalizations
        .of(context)
        .firstDayOfWeekIndex;
    dateIterator = dateIterator.subtract(
        Duration(days: (dateIterator.weekday - (firstDayOfWeek) % 7))
    );
    Duration add = const Duration(days: 1);

    // Create 6 rows
    List<Row> rows = [];
    for (int week = 0; week < 6; week++) {
      List<Widget> days = [];

      // Create 7 cells
      for (int day = 0; day < 7; day++) {
        CalendarCell cell = CalendarCell(dateIterator, (date) => _onSelectedDateSet(date),
          isCurrentMonth: dateIterator.month == firstOfMonth.month);
        days.add(cell);
        cells[dateIterator] = cell;
        
        // Add 1 day to iterator
        dateIterator = dateIterator.add(add);
      }
      // Add cells to row
      rows.add(
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
              children: rows,
            )
        );
      }
    );
  }
}