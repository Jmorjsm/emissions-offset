import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
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
}