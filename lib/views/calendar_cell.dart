import 'dart:ui';

import 'package:canalendar/models/persistency/save_data.dart';
import 'package:canalendar/models/session.dart';
import 'package:canalendar/utils/date_time_util.dart';
import 'package:canalendar/utils/icon_util.dart';
import 'package:canalendar/views/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CalendarCell extends StatefulWidget implements Comparable<CalendarCell> {
  ValueNotifier<DateTime> date;
  ValueNotifier<bool> selected = ValueNotifier(false);
  bool isCurrentMonth;
  ValueNotifier<List<Session>> sessions = ValueNotifier([]);
  Function(DateTime date) onClickedCallback;

  CalendarCell(DateTime date, this.onClickedCallback, {super.key, this.isCurrentMonth = true})
      : date = ValueNotifier<DateTime>(date) {
    sessions.value = SaveData.currentUser.value == null
        ? [] : SaveData.currentUser.value!.getSessions(date);
  }

  void updateData() {
    sessions.value = SaveData.currentUser.value!.getSessions(date.value);
  }

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
    bool isWeekend = widget.date.value.weekday == 6
        || widget.date.value.weekday == 7;
    bool isToday = DateTimeUtil.isSameDay(widget.date.value, DateTime.now());
    return Expanded(
        child: GestureDetector(
            onTap: () => widget._clicked(),
            child: AspectRatio(
                aspectRatio: 1,
                child: ValueListenableBuilder<bool>(
                    valueListenable: widget.selected,
                    builder: (context, isSelected, child) {
                      return Stack(
                          children: [
                            SvgPicture.asset(
                              isToday && !isSelected ?
                                IconUtil.getCannabisHollowIconPath()
                                : IconUtil.getCannabisIconPath(),
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                isToday ? Colors.lightGreen
                                  : (isSelected
                                    ? Colors.lightGreen.shade100
                                    : Colors.transparent), BlendMode.srcIn),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 22),
                                child: Column(
                                    children: [
                                      ValueListenableBuilder<DateTime>(
                                          valueListenable: widget.date,
                                          builder: (context, date, child) {
                                            return Text(
                                                date.day.toString(),
                                                style: TextStyle(
                                                    color: isSelected && isToday ? Colors.white :
                                                    widget.isCurrentMonth
                                                        ? (isWeekend
                                                        ? Colors.black38
                                                        : Colors.black)
                                                        : Colors.black12
                                                ),
                                                textAlign: TextAlign.center
                                            );
                                          }
                                      ),
                                      ValueListenableBuilder<List<Session>>(
                                          valueListenable: widget.sessions,
                                          builder: (context, sessions, child) {
                                            return ValueListenableBuilder<bool>(
                                                valueListenable: CalendarView.lineDisplay,
                                                builder: (context, lineDisplay, child) {
                                                  return lineDisplay
                                                    ? Visibility(
                                                      visible: sessions.isNotEmpty,
                                                      child: Container(
                                                        color: Colors.blue,
                                                        height: 2,
                                                      )
                                                    )
                                                    :Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Visibility(
                                                        visible: sessions.isNotEmpty,
                                                        child: Container(
                                                          width: clampDouble(
                                                              (sessions.length.toDouble() + 1) * 2, 0, 10),
                                                          height: clampDouble((sessions.length.toDouble() + 1) * 2, 0, 10),
                                                          decoration: const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.blue,
                                                          ),
                                                        )
                                                      )
                                                    ]
                                                  );
                                                }
                                            );
                                          }
                                      ),
                                    ]
                                )
                            )
                          ]
                      );
                    }
                )
            )
        )
    );
  }
}
