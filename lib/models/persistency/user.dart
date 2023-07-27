import 'dart:convert';

import 'package:canalendar/enumerations/stock_type.dart';
import 'package:canalendar/models/session.dart';
import 'package:flutter/material.dart';

class User {
  int currentStockIndex = 0;
  int currentVapeIndex = 0;

  String? name;
  StockType standardType = StockType.weed;
  TimeOfDay daySeparator = const TimeOfDay(hour: 0, minute: 0);
  Duration get daySeparatorDuration => Duration(hours: daySeparator.hour, minutes: daySeparator.minute);
  List<Session> sessions = [];
  //List<Stock> stocks = [];
  //List<Vaporizer> vapes = [];

  User();

  User.named(this.name, this.daySeparator);

  User.withStandardType(this.name, this.standardType);

  User.full(this.name, this.standardType, this.daySeparator);

  void addSession(Session session) {
    int index = sessions.indexWhere((s) => session.compareTo(s) <= 0);
    if (index < 0) index = ~index - 1;
    index = index.clamp(0, sessions.length);

    while (index < sessions.length) {
      if (sessions[index].compareTo(session) == 1) break;
      index++;
    }
    sessions.insert(index, session);
  }

  List<Session> getMonthSessions(DateTime dateInMonth, {bool useDaySeparator = true}) {
    dateInMonth = DateTime(dateInMonth.year, dateInMonth.month, 1);

    DateTime endDate =
    DateTime(dateInMonth.year, dateInMonth.month, DateTime(dateInMonth.year, dateInMonth.month + 1, 0).day);
    return getSessions(dateInMonth, endDate, useDaySeparator: useDaySeparator);
  }

  List<Session> getSessions(DateTime startDate, DateTime? endDate, {bool useDaySeparator = true}) {
    if (sessions.isEmpty ||
        (endDate != null && endDate.isBefore(startDate))) return [];

    endDate ??= startDate.add(const Duration(days: 1));

    if (useDaySeparator) {
      startDate = startDate.add(daySeparatorDuration);
      endDate = endDate.add(daySeparatorDuration);
    }
    return sessions
        .where((session) => session.startTime!.isAfter(startDate) && session.startTime!.isBefore(endDate!))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'currentStockIndex': currentStockIndex,
      'currentVapeIndex': currentVapeIndex,
      'standardType' : standardType,
      'daySeparator' : daySeparator,
      'sessions' : sessions.map((session) => session.toJson()).toList()
    };
  }

  /*factory User.fromJson(Map<String, dynamic> json) {
    return SaveData()
      ..currentUserIndex = json['currentUserIndex']
      ..users = (json['users'] as List<dynamic>).map((userData) => User.fromJson(userData)).toList();
  }*/
}
