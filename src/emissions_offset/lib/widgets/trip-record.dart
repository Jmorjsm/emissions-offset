import 'dart:async';

import 'package:emissions_offset/data/trip_formatter.dart';
import 'package:emissions_offset/data/trip_recorder.dart';
import 'package:emissions_offset/models/app_settings.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/unit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TripRecord extends StatefulWidget {
  var appSettings;

  TripRecord({Key key, this.title, this.appSettings}) : super(key: key);
  final String title;

  @override
  _TripRecorderState createState() => _TripRecorderState(this.appSettings);
}

class _TripRecorderState extends State {
  Trip trip;
  TripRecorder tripRecorder;
  bool isRecording = false;
  IconData fabIcon = Icons.play_arrow;
  Unit unit = Unit.Kilometers;

  StreamSubscription<Position> gpsStreamSubscription;

  @override
  void initState() {
    super.initState();

    var dismissButton = TextButton(
      child: Text("Dismiss"),
      onPressed: () {
        // Close the dialog
        Navigator.of(context).pop();
      },
    );

    AlertDialog confirmDialog = AlertDialog(
      title: Text("Warning to user"),
      content: Text(
          "This application must only be used passengers of vehicles. To reduce the risk of distracting the driver, this application must never be used by the driver."),
      actions: [dismissButton],
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return confirmDialog;
          });
    });
  }

  // Initialise this TripRecord with a new trip.
  _TripRecorderState(AppSettings appSettings) {
    this.trip = Trip.withSettings(appSettings);
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
                  subtitle: Text(TripFormatter.formatDistance(
                      this.trip.getDistance(), unit)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Time'),
                  subtitle: Text(TripFormatter.formatElapsedTime(
                      this.trip.getElapsedTime())),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Average Speed'),
                  subtitle: Text(TripFormatter.formatAverageSpeed(
                      this.trip.getAverageSpeed(), unit)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Time'),
                  subtitle: Text(TripFormatter.formatElapsedTime(
                      this.trip.getElapsedTime())),
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
                if (this.trip.tripPoints.isEmpty) {
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
