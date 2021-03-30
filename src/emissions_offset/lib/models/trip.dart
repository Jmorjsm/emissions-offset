import 'package:geolocator/geolocator.dart';

import 'point.dart';
import 'trip_point.dart';

class Trip {
  int id;
  List<TripPoint> tripPoints;

  Trip() {
    this.tripPoints = [];
  }

  addPoint(Point point) {
    var tripPoint = new TripPoint(point);
    this.tripPoints.add(tripPoint);
  }

  addPosition(Position position) {
    // TODO: Make a factory method to convert position to point
    var point =
        new Point(position.longitude, position.latitude, position.altitude);
    this.addPoint(point);
  }

  num getDistance() {}
}
