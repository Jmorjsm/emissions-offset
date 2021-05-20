class Point {
  double longitude;
  double latitude;
  double altitude;

  Point(this.longitude, this.latitude, this.altitude);

  Point.fromJson(Map<String, dynamic> json)
    : longitude = json['longitude'],
      latitude = json['latitude'],
      altitude = json['altitude'];

  Map<String, dynamic> toJson () => {
    'longitude' : longitude,
    'latitude' : latitude,
    'altitude' : altitude,
  };
}