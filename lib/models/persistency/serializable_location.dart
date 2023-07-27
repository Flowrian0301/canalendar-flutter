class SerializableLocation {
  double latitude;
  double longitude;

  SerializableLocation(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lon': longitude
    };
  }

  factory SerializableLocation.fromJson(Map<String, dynamic> json) => SerializableLocation(json['lat'], json['lon']);
}
