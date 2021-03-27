import 'point.dart';
import 'trip_point.dart';

class Trip {
  int id;
  List<TripPoint> tripPoints;

  Trip(){
    this.tripPoints = [];
  }

  addPoint(Point point) {
    var tripPoint = new TripPoint(point);
    this.tripPoints.add(tripPoint);
  }

  num getDistance() {

  }
}