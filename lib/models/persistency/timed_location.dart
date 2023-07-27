import 'package:canalendar/models/persistency/serializable_location.dart';

class TimedLocation {
  DateTime time;
  SerializableLocation? location;

  TimedLocation(this.time, {this.location});

  Map<String, dynamic> toJson() {

    return {
      'time': time.toIso8601String(),
      'location': location!.toJson()
    };
  }
}