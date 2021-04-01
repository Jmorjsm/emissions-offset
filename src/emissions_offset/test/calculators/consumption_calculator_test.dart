import 'package:emissions_offset/calculators/consumption_calculator.dart';
import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/trip_point.dart';
import 'package:emissions_offset/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var dummyVehicle = new Vehicle(0, 0);
  var tonneVehicle = new Vehicle(1000, 0);
  test('calculateSpeed() calculates the speed', () {
    // 0 longitude and 1 longitude are about 111km apart
    var testPoint1 = new Point(0, 0, 0);
    var testPoint2 = new Point(1, 0, 0);

    // Setup datetimes to be 1 hour apart
    var testTripPoint1 = new TripPoint(testPoint1);
    testTripPoint1.setDateTime(new DateTime(2021,1,1,0,0,0));
    var testTripPoint2 = new TripPoint(testPoint2);
    testTripPoint2.setDateTime(new DateTime(2021,1,1,1,0,0));

    // Calculate the speed
    var cc = new ConsumptionCalculator(dummyVehicle);
    var speed = cc.calculateSpeed(testTripPoint1, testTripPoint2);

    // 111km in 1 hour = ~111km/h
    expect(111, speed.round());
  });

  test('calculateRoadGrade() calculates the gradient', () {
    // 0 longitude and 1 longitude are about 111km apart
    var testPoint1 = new Point(0, 0, 0);
    var testPoint2 = new Point(1, 0, 111000);

    // Calculate the road grade
    var cc = new ConsumptionCalculator(dummyVehicle);
    var grade = cc.calculateRoadGrade(testPoint1, testPoint2);

    // 111km up over 111km distance = ~100% gradient
    expect(100, grade.round());
  });

  test('calculate() calculates the consumption for a single trip.', () {
    // 0 longitude and 1 longitude are about 111km apart
    var testPoint1 = new Point(0, 0, 0);
    var testPoint2 = new Point(1, 0, 111000);
    var testPoint3 = new Point(0, 0, 0);

    // Setup datetimes to be 1 hour apart
    var testTripPoint1 = new TripPoint(testPoint1);
    testTripPoint1.setDateTime(new DateTime(2021,1,1,0,0,0));
    var testTripPoint2 = new TripPoint(testPoint2);
    testTripPoint2.setDateTime(new DateTime(2021,1,1,1,0,0));
    var testTripPoint3 = new TripPoint(testPoint3);
    testTripPoint3.setDateTime(new DateTime(2021,1,1,2,0,0));

    // setup the trip
    Trip trip = new Trip();
    trip.tripPoints.add(testTripPoint1);
    trip.tripPoints.add(testTripPoint2);
    trip.tripPoints.add(testTripPoint3);

    // Calculate the road grade
    var cc = new ConsumptionCalculator(tonneVehicle);
    var consumption = cc.calculate(trip);
    print(consumption);

    // 111km up over 111km distance = ~100% gradient
    //expect(100, consumption.round());
  });
}