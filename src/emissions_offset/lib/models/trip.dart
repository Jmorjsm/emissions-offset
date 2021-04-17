import 'package:geolocator/geolocator.dart';

import 'point.dart';
import 'trip_point.dart';

class Trip {
  int id;
  List<TripPoint> tripPoints;

  DateTime startTime;
  DateTime endTime;

  Trip() {
    this.tripPoints = [];
  }

  begin(){
    this.startTime = DateTime.now();
  }

  end(){
    this.endTime = DateTime.now();
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
    List<double> accelerations = [];
    for(var pointIndex=0; pointIndex < this.tripPoints.length-1; pointIndex++){
      var point2 = this.tripPoints[pointIndex];
      double speed1;
      double speed2;

      var time1;
      var time2;

      if(pointIndex <= 0) {
        speed1 = 0;
        time1 = this.startTime;
      }
      else {
        var point1 = this.tripPoints[pointIndex - 1];
        time1 = point1.dateTime;
        var distance1 = Geolocator.distanceBetween(point1.point.latitude, point1.point.longitude, point2.point.latitude, point2.point.longitude);
        var deltaTime1 = point2.dateTime.difference(point1.dateTime);
        speed1 = distance1/deltaTime1.inHours;
      }

      if(pointIndex == this.tripPoints.length-1) {
        speed2 = 0;
        time2 = this.endTime;
      }
      else {
        var point3 = this.tripPoints[pointIndex+1];
        time2 = point3.dateTime;
        var distance2 = Geolocator.distanceBetween(point2.point.latitude, point2.point.longitude, point3.point.latitude, point3.point.longitude);
        var deltaTime2 = point3.dateTime.difference(point2.dateTime);
        speed2 = distance2/deltaTime2.inHours;
      }

      var deltaSpeed = speed2-speed1;
      var deltaTime = time2.difference(time1);

      accelerations.add(deltaSpeed/deltaTime.inHours);
    }

    return accelerations;
  }
}
