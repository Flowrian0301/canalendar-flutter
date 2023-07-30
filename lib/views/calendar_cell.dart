import 'package:canalendar/models/session.dart';
import 'package:canalendar/utils/date_time_util.dart';
import 'package:flutter/material.dart';

class CalendarCell extends StatefulWidget implements Comparable<CalendarCell> {
  ValueNotifier<DateTime> date;
  ValueNotifier<bool> selected = ValueNotifier<bool>(false);
  static bool lineDisplay = true;
  List<Session> sessions;
  Function(DateTime date) onClickedCallback;

  CalendarCell(DateTime date, this.onClickedCallback, {super.key})
      : sessions = [], date = ValueNotifier<DateTime>(date);

  void setSelected(bool isSelected) {
    selected.value = isSelected;
  }

  void _clicked() {
    onClickedCallback(date.value);
  }

  @override
  _CalendarCellState createState() => _CalendarCellState();


  @override
  int compareTo(CalendarCell other) {
    return date.value.compareTo(other.date.value);
  }
}

class _CalendarCellState extends State<CalendarCell> {
  _CalendarCellState();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => widget._clicked(),
        child: AspectRatio(
          aspectRatio: 1,
          child: ValueListenableBuilder<bool>(
            valueListenable: widget.selected,
            builder: (context, isSelected, child) {
              return Container(
                decoration: BoxDecoration(
                  color: widget.selected.value ? Colors.lightGreen : Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: DateTimeUtil.isSameDay(widget.date.value, DateTime.now())
                        ? Colors.green
                        : Colors.transparent,
                      spreadRadius: 2
                    )
                  ]
                ),
                child: Column(
                  children: [
                    ValueListenableBuilder<DateTime>(
                      valueListenable: widget.date,
                      builder: (context, date, child) {
                        return Text(
                          date.day.toString(),
                          textAlign: TextAlign.center
                        );
                      }
                    )
                  ]
                )
              );
            }
          )
        )
      )
    );
  }
}
