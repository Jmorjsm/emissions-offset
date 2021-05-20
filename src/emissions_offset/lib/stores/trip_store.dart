import 'dart:convert';

import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/trip_point.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class TripStore with ChangeNotifier {
  List<Trip> trips;

  static String TripStoreFileName = 'emissions-offset-trips';
  static String TripStoreItemName = "trips";

  final LocalStorage storage = new LocalStorage(TripStoreFileName);

  TripStore() {
    if (trips == null){
      var savedTrips = storage.getItem(TripStoreItemName);
      if(savedTrips != null) {
        debugPrint("savedTrips:");
        debugPrint(savedTrips);
        debugPrint("loaded saved trips:");
        debugPrint(savedTrips.length);

        this.trips = savedTrips;
      }
      else {
        debugPrint("no saved trip file...");
        this.trips = [];
      }
    }
  }

  void addTrip(Trip trip) {
    this.trips.add(trip);
    this.storage.setItem(TripStoreItemName, jsonEncode(this.trips));
    debugPrint(trip.endTime.toString());
    debugPrint(this.trips.length.toString());
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
    testTrip.startTime = new DateTime(2020,12,31,23,59,55);
    testTrip.endTime = DateTime.now();

    testTrip.tripPoints.addAll([testTripPoint1, testTripPoint2, testTripPoint3]);

    this.addTrip(testTrip);
  }
}