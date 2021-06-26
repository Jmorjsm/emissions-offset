import 'package:emissions_offset/calculators/consumption_calculator.dart';
import 'package:emissions_offset/models/fuel_type.dart';
import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/trip_point.dart';
import 'package:emissions_offset/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var dummyVehicle = new Vehicle(0, 0, FuelType.Gasoline);
  var tonneVehicle = new Vehicle(1000, 0, FuelType.Gasoline);
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
    // get the speed in m/s
    var speed = cc.calculateSpeed(testTripPoint1, testTripPoint2);


    // 111km in 1 hour = ~111km/h
    expect((speed * 3.6).round(), 111);
  });

  test('calculateRoadGrade() calculates the gradient', () {
    // 0 longitude and 1 longitude are about 111km apart
    var testPoint1 = new Point(0, 0, 0);
    var testPoint2 = new Point(1, 0, 111000);

    // Calculate the road grade
    var cc = new ConsumptionCalculator(dummyVehicle);
    var grade = cc.calculateRoadGrade(testPoint1, testPoint2);

    // 111km up over 111km distance = ~100% gradient = 1
    expect(1, grade.round());
  });

  test('getVspMode() correctly calculates the vsp buckets', (){
    // test values for each vsp bucket (vsp mode number, test vsp value)
    const testValues = [
      [1, -5],
      [2, -1],
      [3, 0.5],
      [4, 3],
      [5, 5],
      [6, 8],
      [7, 11],
      [8, 15],
      [9, 18],
      [10, 20],
      [11, 25],
      [12, 30],
      [13, 35],
      [14, 45]
    ];

    var cc = new ConsumptionCalculator(dummyVehicle);

    for(var i = 0; i < testValues.length; ++i){
      expect(testValues[i][0], cc.getVspMode(testValues[i][1]));
    }
  });

  test('calculate() calculates the consumption for a single trip.', () {
    // 0 longitude and 1 longitude are about 111km apart
    var testPoint1 = new Point(0, 0, 0);
    var testPoint2 = new Point(1, 0, 0);
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
    trip.startTime = new DateTime(2020,12,31,23,59,55);
    trip.endTime = new DateTime(2021,1,1,2,0,5);
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