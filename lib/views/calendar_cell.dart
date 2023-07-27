import 'package:canalendar/models/session.dart';
import 'package:flutter/material.dart';

class CalendarCell extends StatefulWidget implements Comparable<CalendarCell> {
  final DateTime date;
  final bool lineDisplay;
  final List<Session> sessions;
  final Function()? onClick;

  CalendarCell(this.date, {this.lineDisplay = true, this.onClick})
      : sessions = [],
        super();

  @override
  _CalendarCellState createState() => _CalendarCellState();

  void setDisplayType(bool line) {
    // Implement the setDisplayType method here
  }

  void updateDisplay() {
    // Implement the updateDisplay method here
  }

  void redrawIndicator() {
    // Implement the redrawIndicator method here
  }

  void updateIndicator(bool selected) {
    // Implement the updateIndicator method here
  }

  @override
  int compareTo(CalendarCell other) {
    return date.compareTo(other.date);
  }
}

class _CalendarCellState extends State<CalendarCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: widget.lineDisplay ? buildLineCell() : buildCircleCell(),
    );
  }

  Widget buildLineCell() {
    return Container(
      // Implement the layout for line cell here
    );
  }

  Widget buildCircleCell() {
    return Container(
      // Implement the layout for circle cell here
    );
  }
}
