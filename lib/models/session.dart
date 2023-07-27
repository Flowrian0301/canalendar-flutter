import 'dart:convert';

import 'package:canalendar/enumerations/session_type.dart';
import 'package:canalendar/enumerations/stock_type.dart';
import 'package:canalendar/models/persistency/serializable_location.dart';
import 'package:canalendar/models/persistency/timed_location.dart';

class Session implements Comparable<Session> {
  List<TimedLocation> trackedData = [];
  bool usersStock = false;
  SessionType type = SessionType.joint;
  StockType stockType = StockType.weed;
  int stockRef = -1;

  DateTime? get startTime => trackedData.isNotEmpty ? trackedData[0].time : null;
  SerializableLocation? get startLocation => trackedData.isNotEmpty ? trackedData[0].location : null;

  Session();

  Session.fromOtherUser(this.type, this.stockType, DateTime time, SerializableLocation? location) {
    usersStock = false;
    stockRef = 0;
    trackedData = [];
    addTrackedData(time, location);
  }

  Session.fromUserStock(this.type, this.stockRef, DateTime time, SerializableLocation? location) {
    usersStock = true;
    stockType = StockType.weed; // Replace with the actual default StockType value.
    trackedData = [];
    addTrackedData(time, location);
  }

  void addTrackedData(DateTime time, SerializableLocation? location) {
    trackedData.add(TimedLocation(time, location: location));
  }

  @override
  int compareTo(Session other) {
    return startTime!.compareTo(other.startTime!);
  }

  Map<String, dynamic> toJson() {

    return {
      'type': type,
      'stockType': stockType,
      'stockIndex': stockRef,
      'trackedData' : trackedData.map((data) => data.toJson()).toList()
    };
  }
}
