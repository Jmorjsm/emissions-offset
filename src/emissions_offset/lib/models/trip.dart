import 'dart:convert';

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
  num _distanceCacheTripPointCount = 0;

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

  Trip.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        tripPoints = List<TripPoint>.from(json
            .decode(jsonMap['tripPoints'])
            .map((tripPointJson) => TripPoint.fromJson(tripPointJson))),
        startTime = DateTime.parse(jsonMap['startTime']),
        endTime = DateTime.parse(jsonMap['endTime']),
        _distanceCache = jsonMap['_distanceCache'],
        _fuelConsumed = jsonMap['_fuelConsumed'],
        _carbonEmissions = jsonMap['_carbonEmissions'],
        _elapsedTime = jsonMap['_elapsedTime'],
        _offsetCost = jsonMap['_offsetCost'],
        _averageSpeed = jsonMap['_averageSpeed'],
        vehicle = Vehicle.fromJson(json.decode(jsonMap['vehicle']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripPoints': jsonEncode(tripPoints),
        'startTime': startTime.toString(),
        'endTime': endTime.toString(),
        '_distanceCache': _distanceCache,
        '_fuelConsumed': _fuelConsumed,
        '_carbonEmissions': _carbonEmissions,
        '_elapsedTime': _elapsedTime,
        '_offsetCost': _offsetCost,
        '_averageSpeed': _averageSpeed,
        'vehicle': jsonEncode(vehicle),
      };

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

    if(tripPoints != null && tripPoints.length > 2){

      if(this._distanceCache == null){
        _distanceCache = 0;
      }

      var p1 = this.tripPoints[this.tripPoints.length - 2].point;
      var p2 = this.tripPoints[this.tripPoints.length - 1].point;
      this._distanceCache += Geolocator.distanceBetween(
          p2.latitude,
          p2.longitude,
          p1.latitude,
          p1.longitude);
      this._distanceCacheTripPointCount = this.tripPoints.length;
    }
  }

  num getDistance() {
    if (this._distanceCache == null) {
      return 0;
    }

    return this._distanceCache;
  }

  // Gets the total distance travelled in the trip in meters.
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

  DateTime getStart() {
    if (this.tripPoints.isEmpty) {
      return null;
    }

    return this.tripPoints.first.dateTime;
  }

  DateTime getEnd() {
    if (this.tripPoints.isEmpty) {
      return null;
    }

    return this.tripPoints.last.dateTime;
  }

  String formatDistance() =>
      '${NumberFormat("##00.00").format(this.getDistance()/1000)}km';

  String formatTime() {
    var diff;
    if (this.getEnd() == null || this.getStart() == null) {
      diff = Duration.zero;
    } else {
      diff = this.getEnd().difference(this.getStart());
    }

    return '${diff.inHours.toString().padLeft(2, "0")}:${diff.inMinutes.remainder(60).toString().padLeft(2, "0")}:${diff.inSeconds.remainder(60).toString().padLeft(2, "0")}';
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
