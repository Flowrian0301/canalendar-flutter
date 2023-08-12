import 'package:canalendar/enumerations/stock_type.dart';
import 'package:canalendar/models/session.dart';
import 'package:canalendar/utils/date_time_util.dart';
import 'package:flutter/material.dart';

import '../stock.dart';

class User {
  int currentStockIndex;
  int currentVapeIndex;

  String? name;
  StockType standardType = StockType.weed;
  TimeOfDay daySeparator;
  Duration get daySeparatorDuration => Duration(hours: daySeparator.hour, minutes: daySeparator.minute);
  List<Session> sessions;
  List<Stock> stocks = [];
  //List<Vaporizer> vapes = [];

  User(this.name, {
      this.standardType = StockType.weed,
      this.daySeparator = const TimeOfDay(hour: 0, minute: 0),
      this.currentStockIndex = 0,
      this.currentVapeIndex = 0,
      List<Stock>? stocks,
      List<Session>? sessions,
    }
  ): stocks = stocks ?? [], sessions = sessions ?? [];

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

  void addStock(Stock stock) {
    int index = stocks.indexWhere((s) => stock.compareTo(s) <= 0);
    if (index < 0) index = ~index - 1;
    index = index.clamp(0, stocks.length);

    while (index < stocks.length) {
      if (stocks[index].compareTo(stock) == 1) break;
      index++;
    }
    stocks.insert(index, stock);
  }

  List<Session> getMonthSessions(DateTime dateInMonth, {bool useDaySeparator = true}) {
    dateInMonth = DateTime(dateInMonth.year, dateInMonth.month, 1);

    DateTime endDate =
    DateTime(dateInMonth.year, dateInMonth.month, DateTime(dateInMonth.year, dateInMonth.month + 1, 0).day);
    return getSessions(dateInMonth, endDate: endDate, useDaySeparator: useDaySeparator);
  }

  List<Session> getSessions(DateTime startDate, {DateTime? endDate, bool useDaySeparator = true}) {
    if (sessions.isEmpty ||
        (endDate != null && endDate.isBefore(startDate))) return [];

    endDate ??= startDate.add(const Duration(days: 1));

    if (useDaySeparator) {
      startDate = startDate.add(daySeparatorDuration);
      endDate = endDate.add(daySeparatorDuration);
    }
    return sessions
        .where((session) => (session.startTime!.isAfter(startDate)
        || session.startTime!.isAtSameMomentAs(startDate))
        && session.startTime!.isBefore(endDate!))
        .toList();
  }

  List<Stock> getStocks(DateTime startDate, {DateTime? endDate, bool useDaySeparator = true}) {
    if (stocks.isEmpty ||
        (endDate != null && endDate.isBefore(startDate))) return [];

    endDate ??= startDate.add(const Duration(days: 1));

    if (useDaySeparator) {
      startDate = startDate.add(daySeparatorDuration);
      endDate = endDate.add(daySeparatorDuration);
    }
    return stocks
        .where((stock) => (stock.purchaseDate.isAfter(startDate)
        || stock.purchaseDate.isAtSameMomentAs(startDate))
        && stock.purchaseDate.isBefore(endDate!))
        .toList();
  }

  Map<String, dynamic> toJson() =>
    {
      'name': name,
      'currentStockIndex': currentStockIndex,
      'currentVapeIndex': currentVapeIndex,
      'standardType' : standardType.index,
      'daySeparator' : DateTimeUtil.timeToJson(daySeparator),
      'stocks' : stocks.map((stock) => stock.toJson()).toList(),
      'sessions' : sessions.map((session) => session.toJson()).toList()
    };

  factory User.fromJson(Map<String, dynamic> json) => User(
      json['name'],
      currentStockIndex: json['currentStockIndex'],
      currentVapeIndex: json['currentVapeIndex'],
      standardType: StockType.values[json['standardType']],
      daySeparator: DateTimeUtil.timefromJson(json['daySeparator']),
      stocks: List<Stock>
        .from((json['stocks'] as List<dynamic>).map((stockData)
        => Stock.fromJson(stockData))),
      sessions: List<Session>
        .from((json['sessions'] as List<dynamic>).map((sessionData)
        => Session.fromJson(sessionData))),
    );

}
