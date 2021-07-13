import 'dart:convert';

import 'package:emissions_offset/data/consumption_calculator.dart';
import 'package:emissions_offset/models/app_settings.dart';
import 'package:emissions_offset/models/unit.dart';
import 'package:emissions_offset/models/vehicle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'fuel_type.dart';
import 'point.dart';
import 'trip_point.dart';

class Trip {
  List<TripPoint> tripPoints;

  DateTime startTime;
  DateTime endTime;

  num _distanceCache;

  num _fuelConsumed;
  num _carbonEmissions;
  Duration _elapsedTime;
  num _offsetCost;
  num _averageSpeed;

  Vehicle vehicle;

  // Create the trip based on the provided settings
  Trip.withSettings(AppSettings settings) {
    this.tripPoints = [];
    this.vehicle = settings.vehicle;

    // Set the carbon emissions per L fuel consumption value
    switch (vehicle.fuelType) {
      case FuelType.Gasoline:
        emissionsPerLitreConsumed = 2.29;
        break;
      case FuelType.Diesel:
        emissionsPerLitreConsumed = 2.66;
        break;
    }

    this.OffsetCostPerKg =
        (settings.offsetCostPerTonne / 1000) * settings.offsetCostMultiplier;
  }

  // Create a trip with the default vehicle, used for testing
  Trip() {
    this.tripPoints = [];
    this.vehicle = new Vehicle(750, 0.3, FuelType.Gasoline);
  }

  // Convert the json object to a trip
  Trip.fromJson(Map<String, dynamic> jsonMap)
      : tripPoints = List<TripPoint>.from(json
            .decode(jsonMap['tripPoints'])
            .map((tripPointJson) => TripPoint.fromJson(tripPointJson))),
        startTime = DateTime.parse(jsonMap['startTime']),
        endTime = DateTime.parse(jsonMap['endTime']),
        _distanceCache = jsonMap['_distanceCache'],
        _fuelConsumed = jsonMap['_fuelConsumed'],
        _carbonEmissions = jsonMap['_carbonEmissions'],
        _offsetCost = jsonMap['_offsetCost'],
        _averageSpeed = jsonMap['_averageSpeed'],
        vehicle = Vehicle.fromJson(json.decode(jsonMap['vehicle']));

  // Convert the trip to a json object
  Map<String, dynamic> toJson() => {
        'tripPoints': jsonEncode(tripPoints),
        'startTime': startTime.toString(),
        'endTime': endTime.toString(),
        '_distanceCache': _distanceCache,
        '_fuelConsumed': _fuelConsumed,
        '_carbonEmissions': _carbonEmissions,
        '_offsetCost': _offsetCost,
        '_averageSpeed': _averageSpeed,
        'vehicle': jsonEncode(vehicle),
      };

  // start the trip
  begin() {
    this.startTime = DateTime.now();
  }

  // Complete the current trip and calculate any final values.
  end() {
    this.endTime = DateTime.now();

    // Call all the getters to ensure this is set when serialising/saving.
    getAverageSpeed();
    getFuelConsumed();
    getCarbonEmissions();
    getOffsetCost();

    // Clear the trip points so this doesn't get stored.
    this.tripPoints = [];
  }

  // Add a gps point to the trip
  addPoint(Point point) {
    var tripPoint = new TripPoint(point);
    this.tripPoints.add(tripPoint);
  }

  // Add a gps position to the trip and add to the cached distance value.
  addPosition(Position position) {
    var point =
        new Point(position.longitude, position.latitude, position.altitude);
    this.addPoint(point);

    if (tripPoints != null && tripPoints.length > 2) {
      if (this._distanceCache == null) {
        _distanceCache = 0;
      }

      var p1 = this.tripPoints[this.tripPoints.length - 2].point;
      var p2 = this.tripPoints[this.tripPoints.length - 1].point;
      num latestDistance = Geolocator.distanceBetween(
          p2.latitude, p2.longitude, p1.latitude, p1.longitude);

      this._distanceCache += latestDistance;
    }
  }

  // Gets the distance in meters
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
        speed1 = distance1 /
            (deltaTime1.inMicroseconds / Duration.microsecondsPerSecond);
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
        speed2 = distance2 /
            (deltaTime2.inMicroseconds / Duration.microsecondsPerSecond);
      }

      var deltaSpeed = speed2 - speed1;
      var deltaTime = time2.difference(time1);

      accelerations.add(deltaSpeed /
          (deltaTime.inMicroseconds / Duration.microsecondsPerSecond));
    }

    return accelerations;
  }

  DateTime getStart() {
    if (this.tripPoints != null && this.tripPoints.isNotEmpty) {
      this.startTime = this.tripPoints.first.dateTime;
    }

    return this.startTime;
  }

  DateTime getEnd() {
    if (this.tripPoints != null && this.tripPoints.isNotEmpty) {
      this.endTime = this.tripPoints.last.dateTime;
    }

    return this.endTime;
  }

  num getFuelConsumed() {
    if (this._fuelConsumed == null) {
      this._fuelConsumed = ConsumptionCalculator(this.vehicle).calculate(this);
    }

    return this._fuelConsumed;
  }

  // Multipliers
  // Emissions in kg per litre of fuel consumed, from
  // https://www.nrcan.gc.ca/sites/www.nrcan.gc.ca/files/oee/pdf/transportation/fuel-efficient-technologies/autosmart_factsheet_6_e.pdf
  num emissionsPerLitreConsumed = 2.3;
  num OffsetCostPerKg = 0.50;

  num getCarbonEmissions() {
    if (this._carbonEmissions == null) {
      this._carbonEmissions =
          this.getFuelConsumed() * emissionsPerLitreConsumed;
    }

    return this._carbonEmissions;
  }

  num getOffsetCost() {
    if (this._offsetCost == null) {
      this._offsetCost = this.getCarbonEmissions() * OffsetCostPerKg;
    }

    return this._offsetCost;
  }

  Duration getElapsedTime() {
    if (this.getEnd() == null || this.getStart() == null) {
      this._elapsedTime = Duration.zero;
    } else {
      this._elapsedTime = this.getEnd().difference(this.getStart());
    }

    return this._elapsedTime;
  }
  // Returns the average speed in meters per second.
  num getAverageSpeed() {
    var distanceInMeters = this.getDistance();
    var time = getElapsedTime().inSeconds;

    // Avoid division by 0
    if (distanceInMeters == 0 || time == 0) {
      return 0;
    }

    this._averageSpeed = distanceInMeters / time;

    return this._averageSpeed;
  }
}
