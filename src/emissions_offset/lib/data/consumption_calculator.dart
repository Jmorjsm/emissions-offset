import 'dart:math';
import 'package:emissions_offset/models/fuel_type.dart';
import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/trip_point.dart';
import 'package:emissions_offset/models/vehicle.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class ConsumptionCalculator {
  Vehicle vehicle;

  ConsumptionCalculator(Vehicle vehicle) {
    this.vehicle = vehicle;
  }

  double calculate(Trip trip) {
    double totalConsumption = 0;
    var accelerations = trip.getAccelerations();

    for (var pointIndex = 1;
        pointIndex < trip.tripPoints.length - 1;
        pointIndex++) {
      // Get the first point
      var p1 = trip.tripPoints[pointIndex - 1];

      // Get the second point
      var p2 = trip.tripPoints[pointIndex];

      // get the input parameters for the numerator
      var m = this.vehicle.mass;

      // acceleration in m/s/s
      var a = accelerations[pointIndex - 1];

      // acceleration due to gravity (m/s/s)
      var g = 9.81;

      // road gradient (radians)
      var grade = this.calculateRoadGrade(p1.point, p2.point);

      // road gradient
      var dragCoefficient = this.vehicle.dragCoefficient;
      var rollingResistanceCoefficient = 0.02;

      // speed in m/s
      var vs = this.calculateSpeed(p1, p2);
      var vs3 = vs * vs * vs;

      // VSP formula
      var vspPower = (vs * (a + g * sin(grade) + rollingResistanceCoefficient) + dragCoefficient * vs3) / m;
      var vspMode = getVspMode(vspPower);
      var instantaneousConsumption = getConsumptionForMode(vspMode, this.vehicle.fuelType);

      debugPrint("vspPower: "+ vspPower.toString()+", vspMode: "+ vspMode.toString() + "consumption: " + instantaneousConsumption.toString());

      totalConsumption += instantaneousConsumption;
   }

    return totalConsumption;
  }

  // array containing the upper bounds of VSP power value buckets
  static const List<int> VspModeBoundaries = [-2, 0, 1, 4, 7, 10, 13, 16, 19, 23, 28, 33, 39];
  int getVspMode(num vspPower){
    int vspMode = 1;
    // Loop through the lower bounds for each vsp bucket, incrementing the mode value until the power is less than the upper bound
    for (var vspIndex = 0; vspIndex < VspModeBoundaries.length; ++vspIndex){
      if (vspPower < VspModeBoundaries[vspIndex]){
        break;
      }

      ++vspMode;
    }

    return vspMode;
  }

  static const Map<FuelType, List<num>> VspConsumptions = {
    FuelType.Gasoline: [0.01244, 0.01866, 0.020526, 0.0622, 0.08397, 0.11507, 0.14306, 0.16794, 0.19904, 0.22703, 0.27368, 0.28101, 0.31394, 0.34566],
    FuelType.Diesel: [0.01116, 0.01674, 0.018414, 0.0558, 0.07533, 0.10323, 0.12834, 0.15066, 0.17856, 0.20367, 0.24552, 0.25209, 0.28163, 0.31009],
  };
  num getConsumptionForMode(int vspMode, FuelType fuelType) {
    // subtract 1 to get the index
    var modeIndex = vspMode - 1;
    return VspConsumptions[fuelType][modeIndex];
  }

  double calculateMultiple(List<Trip> trips) {
    double total = 0;
    for (var tripIndex = 0; tripIndex < trips.length; ++tripIndex) {
      total += this.calculate(trips[tripIndex]);
    }

    return total / (trips.length);
  }

  double calculateRoadGrade(Point point1, Point point2) {
    var distance = Geolocator.distanceBetween(
        point2.latitude, point2.longitude, point1.latitude, point1.longitude);
    if(distance == 0){
      return 0;
    }

    var deltaAltitude = point2.altitude - point1.altitude;

    return atan(deltaAltitude / distance);
  }

  // Returns the speed in meters per second
  double calculateSpeed(TripPoint tripPoint1, TripPoint tripPoint2) {
    var point1 = tripPoint1.point;
    var point2 = tripPoint2.point;

    var distance = Geolocator.distanceBetween(
        point2.latitude, point2.longitude, point1.latitude, point1.longitude);
    var deltaTime = tripPoint2.dateTime.difference(tripPoint1.dateTime);

    return distance / (deltaTime.inMicroseconds/Duration.microsecondsPerSecond);
  }
}
