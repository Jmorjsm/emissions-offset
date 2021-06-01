import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/unit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: Populate info fields
// TODO: Implement delete
class TripDetail extends StatelessWidget {
  final Trip trip;
  final Unit unit = Unit.Kilometers;

  // Initialise this TripDetail with the provided trip.
  const TripDetail({Key key, this.trip}) : super(key: key);

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
                  subtitle: Text(trip.formatFuelConsumed()),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Carbon emitted'),
                  subtitle: Text(trip.formatCarbonEmissions()),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Distance'),
                  subtitle: Text(trip.formatDistance(unit)),
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
                  title: Text('Offset cost'),
                  subtitle: Text(trip.formatOffsetCost()),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Average speed'),
                  subtitle: Text(trip.formatAverageSpeed(unit)),
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
    );
  }
}
