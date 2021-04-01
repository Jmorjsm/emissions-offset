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

  num getDistance() {
    double totalDistance = 0;
    for (var pointIndex=1; pointIndex <this.tripPoints.length; pointIndex++) {
      var p1 = this.tripPoints[pointIndex-1].point;
      var p2 = this.tripPoints[pointIndex].point;
      totalDistance += Geolocator.distanceBetween(p2.latitude, p2.longitude, p1.latitude, p1.longitude);
    }
    return totalDistance;
  }

  List<double> getAccelerations()
  {
    return [0,111,0];
  }
}
