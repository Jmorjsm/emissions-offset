import 'point.dart';

class TripPoint {
  Point point;
  DateTime dateTime;

  TripPoint(Point point) {
    this.point = point;
    this.dateTime = DateTime.now();
  }
}