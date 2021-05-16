import 'package:emissions_offset/data/trip_recorder.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: Return the recorded trip to the trip store
class TripRecord extends StatelessWidget {
  final Trip trip;
  TripRecorder tr;

  // Initialise this TripRecord with a new trip.
  TripRecord(this.trip) {
    this.tr = TripRecorder();
    this.tr.registerGpsHandler(this.trip);
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
        child: Icon(Icons.play_arrow),
        onPressed: () {
          if(!this.tr.isRecording){
            this.tr.start();

          } else {
            this.tr.pause();
          }
        }
      ),
    );
  }
}
