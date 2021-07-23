import 'package:emissions_offset/data/trip_formatter.dart';
import 'package:emissions_offset/models/app_settings.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/unit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripDetail extends StatelessWidget {
  final Trip trip;
  var unit;

  // Initialise this TripDetail with the provided trip.
  TripDetail({Key key, this.trip, this.unit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Detail'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Fuel Consumed'),
                  subtitle: Text(TripFormatter.FormatFuelConsumed(trip.getFuelConsumed())),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Carbon emitted'),
                  subtitle: Text(TripFormatter.FormatCarbonEmissions(trip.getCarbonEmissions())),
                ),
              ),
            ],
          ),
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
                  title: Text('Offset cost'),
                  subtitle: Text(TripFormatter.FormatOffsetCost(trip.getOffsetCost())),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Average speed'),
                  subtitle: Text(TripFormatter.formatAverageSpeed(trip.getAverageSpeed(), unit)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Start time'),
                  subtitle: Text(trip.startTime.toString()),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('End time'),
                  subtitle: Text(trip.endTime.toString()),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(CupertinoIcons.trash),
          onPressed: () {
            // Navigate back and say we did want to delete the trip.
            Navigator.of(context).pop(true);
          }),
    );
  }
}
