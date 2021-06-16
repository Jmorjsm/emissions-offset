import 'dart:math';

import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/trip_point.dart';
import 'package:emissions_offset/models/vehicle.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class ConsumptionCalculator {
  Vehicle vehicle;

  ConsumptionCalculator(Vehicle vehicle) {
    this.vehicle = vehicle;
  }

  double calculate(Trip trip) {
    double totalConsumption = 0;
    var accelerations = trip.getAccelerations();
    var VSPs = [];
    for (var pointIndex = 1;
        pointIndex < trip.tripPoints.length - 1;
        pointIndex++) {
      // scalar for engine efficiency
      var s = 0.2;

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
      var vs2 = vs*vs;

      // calculate this denominator
      var denominator = m * (a + g * sin(grade) + rollingResistanceCoefficient + dragCoefficient + vs2);

      // calculate this consumption rate value and add to the ongoing values list
      var consumptionRate = s / denominator;

      num distance = Geolocator.distanceBetween(
          p2.point.latitude,
          p2.point.longitude,
          p1.point.latitude,
          p1.point.longitude);

      // Only include if consumption rate is positive
      if(distance > 0 && consumptionRate > 0) {
        var consumedFuel = consumptionRate / distance;
        totalConsumption += consumedFuel;
      }

      // VSP
      var vs3 = vs * vs * vs;
      var VSP = vs * (a + g * sin(grade) + rollingResistanceCoefficient) + dragCoefficient * vs3;

      VSPs.add(VSP);
   }

    debugPrint(VSPs.toString());
    return totalConsumption;
  }

  double calculateMultiple(List<Trip> trips) {
    double total = 0;
    for (var tripIndex = 0; tripIndex < trips.length; tripIndex++) {
      total += this.calculate(trips[tripIndex]);
    }
    return total / (trips.length);
  }

  //todo make private
  double calculateRoadGrade(Point point1, Point point2) {
    var deltaAltitude = point2.altitude - point1.altitude;
    var distance = Geolocator.distanceBetween(
        point2.latitude, point2.longitude, point1.latitude, point1.longitude);

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
