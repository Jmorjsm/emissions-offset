import 'dart:async';

import 'package:emissions_offset/data/trip-formatter.dart';
import 'package:emissions_offset/data/trip_recorder.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/unit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TripRecord extends StatefulWidget {
  TripRecord({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TripRecorderState createState() => _TripRecorderState();
}

class _TripRecorderState extends State {
  Trip trip;
  TripRecorder tripRecorder;
  bool isRecording = false;
  IconData fabIcon = Icons.play_arrow;
  Unit unit = Unit.Kilometers;

  StreamSubscription<Position> gpsStreamSubscription;

  // Initialise this TripRecord with a new trip.
  _TripRecorderState() {
    this.trip = Trip();
    this.tripRecorder = TripRecorder();
    this.gpsStreamSubscription = this
        .tripRecorder
        .registerGpsHandler(this.trip, this.updateTripStateCallback);
  }

  void updateTripStateCallback(Position position) {
    setState(() {
      if (this.isRecording) {
        if (position != null) {
          trip.addPosition(position);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => this.complete(),
        ),
        title: Text('Trip Recording'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Distance'),
                  subtitle: Text(TripFormatter.formatDistance(trip.getDistance(), unit)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Time'),
                  subtitle: Text(TripFormatter.formatElapsedTime(trip.getElapsedTime())),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Average Speed'),
                  subtitle: Text(TripFormatter.formatAverageSpeed(this.trip.getAverageSpeed(), unit)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Time'),
                  subtitle: Text(TripFormatter.formatElapsedTime(trip.getElapsedTime())),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(fabIcon),
          onPressed: () {
            setState(() {
              if (!this.isRecording) {
                if (trip.tripPoints.isEmpty) {
                  this.start();
                } else {
                  this.resume();
                }
              } else {
                this.pause();
              }
            });
          }),
    );
  }

  start() {
    this.isRecording = true;
    this.trip.begin();
    this.fabIcon = Icons.pause;
  }

  pause() {
    this.isRecording = false;
    this.fabIcon = Icons.play_arrow;
    this.gpsStreamSubscription.pause();
  }

  resume() {
    this.isRecording = true;
    this.fabIcon = Icons.pause;
    this.gpsStreamSubscription.resume();
  }

  finish() {
    this.isRecording = false;

    if (this.gpsStreamSubscription != null) {
      this.gpsStreamSubscription.cancel();
    }

    this.trip.end();
  }

  void complete() {
    this.finish();
    Navigator.of(context).pop(this.trip);
  }
}
