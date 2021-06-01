import 'dart:convert';

import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/trip_point.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class TripStore with ChangeNotifier {
  List<Trip> trips = [];

  static const String TripStoreFileName = 'emissions-offset-trips';
  static const String TripStoreItemName = "trips";

  final LocalStorage storage = new LocalStorage(TripStoreFileName);

  TripStore() {
    storage.ready.then((_) => loadTrips());
  }

  void addTrip(Trip trip) {
    this.trips.add(trip);
    this.storage.setItem(TripStoreItemName, jsonEncode(this.trips));
    notifyListeners();
  }

  void addTestTrip() {
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
    testTrip.startTime = new DateTime(2020, 12, 31, 23, 59, 55);
    testTrip.endTime = DateTime.now();

    testTrip.tripPoints
        .addAll([testTripPoint1, testTripPoint2, testTripPoint3]);

    this.addTrip(testTrip);
  }

  loadTrips() {
    var tripListJson = storage.getItem(TripStoreItemName);
    if (tripListJson != null) {
      debugPrint("savedTrips:");
      debugPrint(tripListJson);
      debugPrint("loaded saved trips:");

      var tripList = json.decode(tripListJson);

      this.trips =
          List<Trip>.from(tripList.map((tripJson) => Trip.fromJson(tripJson)));

      if (this.trips != null) {
        debugPrint(this.trips.length.toString());
      }
    } else {
      debugPrint("no saved trip file...");
      this.trips = [];
    }
    // Tell the ui that we're done loading.
    notifyListeners();
  }

  clear() {
    this.storage.deleteItem(TripStoreItemName);
    this.trips = [];
    notifyListeners();
  }
}
