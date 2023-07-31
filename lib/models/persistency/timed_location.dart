import 'package:canalendar/models/persistency/serializable_location.dart';

class TimedLocation {
  DateTime time;
  SerializableLocation? location;

  TimedLocation(this.time, {this.location});

  Map<String, dynamic> toJson() =>
    {
      'time': time.toIso8601String(),
      'location': location!.toJson()
    };

  factory TimedLocation.fromJson(Map<String, dynamic> json) {
    dynamic locationData = json['location'];
    return TimedLocation(
      DateTime.parse(json['time']),
      location: locationData != null ? SerializableLocation.fromJson(locationData) : null,
    );
  }
}