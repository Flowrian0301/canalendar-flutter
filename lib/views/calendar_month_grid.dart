import 'package:canalendar/views/calendar_cell.dart';
import 'package:flutter/material.dart';

class CalendarMonthGrid extends StatelessWidget {
  DateTime firstOfMonth = DateTime.now();
  Map<DateTime, CalendarCell> cells = {};
  final Function(DateTime date) _onSelectedDateSet;

  CalendarMonthGrid(this._onSelectedDateSet, {super.key}) {
    DateTime now = DateTime.now();
    firstOfMonth = DateTime(now.year, now.month);
  }

  void updateSelectedDate(DateTime date, {DateTime? oldDate}) {
    cells[oldDate]?.setSelected(false);
    cells[date]?.setSelected(true);
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
        CalendarCell cell = CalendarCell(dateIterator, (date) => _onSelectedDateSet(date));
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

    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    updateSelectedDate(now);

    // Create layout
    return Align(
        child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth > 400 ? 400 : constraints
                  .maxWidth;
              return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                  ),
                  child: Wrap(
                    children: rows,
                  )
              );
            }
        )
    );
  }
}