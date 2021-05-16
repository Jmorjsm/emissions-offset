import 'package:emissions_offset/data/trip_recorder.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// TODO: Return the recorded trip to the trip store
class TripRecord extends StatefulWidget {
  TripRecord({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _TripRecorderState createState() => _TripRecorderState();
}

class _TripRecorderState extends State {
  Trip trip;
  TripRecorder tr;
  bool isRecording = false;
  IconData fabIcon = Icons.play_arrow;

  // Initialise this TripRecord with a new trip.
  _TripRecorderState() {
    this.trip = Trip();
    this.tr = TripRecorder();
    this.tr.registerGpsHandler(this.trip, this.updateTripStateCallback);
  }

  void updateTripStateCallback (Position position) {
    setState(() {
      if (this.isRecording) {
        if (position != null) {
          trip.addPosition(position);
        }
      }

      print("isRecording: " + this.isRecording.toString());
      print(position == null ? 'Unknown' : position.latitude.toString() + ', '
          + position.longitude.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Recording'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Distance'),
                  subtitle: Text(trip.formatDistance()),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Time'),
                  subtitle: Text(trip.formatTime()),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('point count'),
                  subtitle: Text(this.trip.tripPoints.length.toString()),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Time'),
                  subtitle: Text(trip.formatTime()),
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
              if(!this.isRecording){
                if(trip.tripPoints.isEmpty) {
                  this.start();
                } else {
                  this.resume();
                }
              } else {
                this.pause();
              }
            });
          }
      ),
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
  }

  resume() {
    this.isRecording = true;
    this.fabIcon = Icons.pause;
  }

  finish() {
    this.isRecording = false;
    this.trip.end();
  }
}
