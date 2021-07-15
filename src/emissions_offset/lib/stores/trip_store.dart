import 'dart:convert';

import 'package:emissions_offset/models/point.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/trip_point.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class TripStore with ChangeNotifier {
  List<Trip> trips = [];

  static const String _tripStoreFileName = 'emissions-offset-trips';
  static const String _tripStoreItemName = "trips";

  final LocalStorage storage = new LocalStorage(_tripStoreFileName);

  TripStore() {
    storage.ready.then((_) => loadTrips());
  }

  void addTrip(Trip trip) {
    this.trips.add(trip);
    this.storage.setItem(_tripStoreItemName, jsonEncode(this.trips));
    notifyListeners();
  }

  void deleteTrip(int index) {
    this.trips.removeAt(index);
    this.storage.setItem(_tripStoreItemName, jsonEncode(this.trips));
    notifyListeners();
  }

  loadTrips() {
    var tripListJson = storage.getItem(_tripStoreItemName);
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
    this.storage.deleteItem(_tripStoreItemName);
    this.trips = [];
    notifyListeners();
  }
}
