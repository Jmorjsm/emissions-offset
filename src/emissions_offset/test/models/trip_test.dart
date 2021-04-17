import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/trip_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('addPoint() adds the new point', () {
    var testTrip = new Trip();
    var testPoint = new Point(0, 0, 0);

    testTrip.addPoint(testPoint);

    expect(1, testTrip.tripPoints.length);
    expect(0, testTrip.tripPoints[0].point.longitude);
    expect(0, testTrip.tripPoints[0].point.latitude);
    expect(0, testTrip.tripPoints[0].point.altitude);
  });

  test('getAccelerations() calculates the accelerations', ()
  {
    // 0 longitude and 1 longitude are about 111km apart
    var testPoint1 = new Point(0, 0, 0);
    var testPoint2 = new Point(1, 0, 111000);
    var testPoint3 = new Point(0, 0, 0);

    // Setup datetimes to be 1 hour apart
    var testTripPoint1 = new TripPoint(testPoint1);
    testTripPoint1.setDateTime(new DateTime(2021, 1, 1, 0, 0, 0));
    var testTripPoint2 = new TripPoint(testPoint2);
    testTripPoint2.setDateTime(new DateTime(2021, 1, 1, 1, 0, 0));
    var testTripPoint3 = new TripPoint(testPoint3);
    testTripPoint3.setDateTime(new DateTime(2021, 1, 1, 2, 0, 0));

    var testTrip = new Trip();
    testTrip.startTime = new DateTime(2020,12,31,23,59,55);
    testTrip.endTime = new DateTime(2021,1,1,2,0,5);

    testTrip.tripPoints.addAll([testTripPoint1, testTripPoint2, testTripPoint3]);
    var accelerations = testTrip.getAccelerations();
    print(accelerations);
  });
  }