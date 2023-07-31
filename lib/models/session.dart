import 'package:canalendar/enumerations/session_type.dart';
import 'package:canalendar/enumerations/stock_type.dart';
import 'package:canalendar/models/persistency/serializable_location.dart';
import 'package:canalendar/models/persistency/timed_location.dart';

class Session implements Comparable<Session> {
  List<TimedLocation> trackedData = [];
  bool usersStock = false;
  SessionType type = SessionType.joint;
  StockType? stockType;
  int? stockRef;

  DateTime? get startTime => trackedData.isNotEmpty ? trackedData[0].time : null;
  SerializableLocation? get startLocation => trackedData.isNotEmpty ? trackedData[0].location : null;

  Session();

  Session.fromOtherUser(this.type, this.stockType, DateTime time, SerializableLocation? location) {
    usersStock = false;
    trackedData = [];
    addTrackedData(time, location);
  }

  Session.fromOtherUserWithData(this.type, this.stockType, this.trackedData) {
    usersStock = false;
  }

  Session.fromUserStock(this.type, this.stockRef, DateTime time, SerializableLocation? location) {
    usersStock = true;
    trackedData = [];
    addTrackedData(time, location);
  }

  Session.fromUserStockWithData(this.type, this.stockRef, this.trackedData) {
    usersStock = true;
  }

  void addTrackedData(DateTime time, SerializableLocation? location) {
    trackedData.add(TimedLocation(time, location: location));
  }

  @override
  int compareTo(Session other) {
    return startTime!.compareTo(other.startTime!);
  }

  Map<String, dynamic> toJson() {
    if (usersStock) {
      return {
        'type': type.index,
        'stockIndex': stockRef,
        'trackedData' : trackedData.map((data) => data.toJson()).toList()
      };
    }
    return
      {
        'type': type.index,
        'stockType': stockType?.index,
        'trackedData' : trackedData.map((data) => data.toJson()).toList()
      };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    SessionType sessionType = SessionType.values[json['type']];
    List<TimedLocation> trackedData =
      List<TimedLocation>.from((json['trackedData'] as List<dynamic>).map((trackedData)
      => TimedLocation.fromJson(trackedData)));

    if (json['stockType'] == null) {
      return Session.fromUserStockWithData(
        sessionType,
        json['stockIndex'],
        trackedData
      );
    }

    return Session.fromOtherUserWithData(
        sessionType,
        StockType.values[json['stockType']],
        trackedData
    );
  }
}
