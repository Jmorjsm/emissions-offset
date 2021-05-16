import 'package:emissions_offset/calculators/consumption_calculator.dart';
import 'package:emissions_offset/models/vehicle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'point.dart';
import 'trip_point.dart';

class Trip {
  int id;
  List<TripPoint> tripPoints;

  DateTime startTime;
  DateTime endTime;

  num _distanceCache;
  int _distanceCacheTripPointCount;

  num _fuelConsumed;
  num _carbonEmissions;
  Duration _elapsedTime;
  num _offsetCost;
  num _averageSpeed;

  Vehicle vehicle;
  ConsumptionCalculator consumptionCalculator;

  Trip() {
    this.tripPoints = [];
    this.vehicle = new Vehicle(750, 0.3);
    this.consumptionCalculator = new ConsumptionCalculator(this.vehicle);
  }

  begin() {
    this.startTime = DateTime.now();
  }

  end() {
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
    if (this._distanceCache == null ||
        this.tripPoints.length > this._distanceCacheTripPointCount) {
      this._distanceCache = this.calculateDistance();
      this._distanceCacheTripPointCount = tripPoints.length;
    }

    return this._distanceCache;
  }

  num calculateDistance() {
    double totalDistance = 0;
    for (var pointIndex = 1;
        pointIndex < this.tripPoints.length;
        pointIndex++) {
      var p1 = this.tripPoints[pointIndex - 1].point;
      var p2 = this.tripPoints[pointIndex].point;
      totalDistance += Geolocator.distanceBetween(
          p2.latitude, p2.longitude, p1.latitude, p1.longitude);
    }

    return totalDistance;
  }

  List<double> getAccelerations() {
    List<double> accelerations = [];
    for (var pointIndex = 0;
        pointIndex < this.tripPoints.length - 1;
        pointIndex++) {
      var point2 = this.tripPoints[pointIndex];
      double speed1;
      double speed2;

      var time1;
      var time2;

      if (pointIndex <= 0) {
        speed1 = 0;
        time1 = this.startTime;
      } else {
        var point1 = this.tripPoints[pointIndex - 1];
        time1 = point1.dateTime;
        var distance1 = Geolocator.distanceBetween(
            point1.point.latitude,
            point1.point.longitude,
            point2.point.latitude,
            point2.point.longitude);
        var deltaTime1 = point2.dateTime.difference(point1.dateTime);
        speed1 = distance1 / deltaTime1.inHours;
      }

      if (pointIndex == this.tripPoints.length - 1) {
        speed2 = 0;
        time2 = this.endTime;
      } else {
        var point3 = this.tripPoints[pointIndex + 1];
        time2 = point3.dateTime;
        var distance2 = Geolocator.distanceBetween(
            point2.point.latitude,
            point2.point.longitude,
            point3.point.latitude,
            point3.point.longitude);
        var deltaTime2 = point3.dateTime.difference(point2.dateTime);
        speed2 = distance2 / deltaTime2.inHours;
      }

      var deltaSpeed = speed2 - speed1;
      var deltaTime = time2.difference(time1);

      accelerations.add(deltaSpeed / deltaTime.inHours);
    }

    return accelerations;
  }

  String formatDistance() =>
      '${NumberFormat("####.00").format(this.getDistance())}km';

  String formatTime() {
    var diff;
    if(this.endTime == null){
      diff = Duration.zero;
    } else {
      diff = this.endTime.difference(this.startTime);
    }

    return '${diff.inHours}:${diff.inMinutes.remainder(60)}:${diff.inSeconds.remainder(60)}';
  }

  num getFuelConsumed() {
    if (this._fuelConsumed == null) {
      this._fuelConsumed = this.consumptionCalculator.calculate(this);
    }

    return this._fuelConsumed;
  }

  num getCarbonEmissions() {
    if (this._carbonEmissions == null) {
      this._carbonEmissions = this.getFuelConsumed() * 2.3;
    }

    return this._carbonEmissions;
  }

  Duration getElapsedTime() {
    if (this._elapsedTime == null && this.endTime != null) {
      this._elapsedTime = this.endTime.difference(this.startTime);
    }

    return this._elapsedTime;
  }

  num getOffsetCost() {
    if (this._offsetCost == null) {
      this._offsetCost = this.getCarbonEmissions() * 0.50;
    }

    return this._offsetCost;
  }

  num getAverageSpeed() {
    if (this._averageSpeed == null) {
      this._averageSpeed = this.getAverageSpeed();
    }

    return this._averageSpeed;
  }
}
