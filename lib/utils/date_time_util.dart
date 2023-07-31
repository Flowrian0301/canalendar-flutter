import 'package:flutter/material.dart';

final class DateTimeUtil {
  static isSameDay(DateTime date1, DateTime date2) => date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;

  static Map<String, dynamic> timeToJson(TimeOfDay time) =>
    {
      'hour': time.hour,
      'minute': time.minute
    };

  static TimeOfDay timefromJson(Map<String, dynamic> json) =>
    TimeOfDay(
      hour: json['hour'],
      minute: json['minute']
    );
}