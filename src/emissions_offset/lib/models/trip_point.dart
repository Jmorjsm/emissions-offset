import 'point.dart';

class TripPoint {
  Point point;
  DateTime dateTime;

  TripPoint(Point point) {
    this.point = point;
    this.dateTime = DateTime.now();
  }

  TripPoint.fromJson(Map<String, dynamic> json)
      : point = Point.fromJson(json['point']),
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() => {
        'point': point,
        'dateTime': dateTime.toString(),
      };

  setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
  }
}
