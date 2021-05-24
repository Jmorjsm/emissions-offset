import 'dart:async';

import 'package:emissions_offset/models/trip.dart';
import 'package:geolocator/geolocator.dart';

class TripRecorder {
  StreamSubscription<Position> registerGpsHandler(
      Trip trip, void Function(Position position) updateTripStateCallback) {
    return Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best)
        .listen(updateTripStateCallback);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions permanently denied. Please resolve this in your device settings.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
