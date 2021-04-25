import 'package:emissions_offset/models/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: Pass through current trip to this page
// TODO: Populate info fields
// TODO: Implement delete
class TripDetail extends StatelessWidget {
  final Trip trip;

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
                  subtitle: Text('1.0L'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Carbon emitted'),
                  subtitle: Text('2.3kg'),
                ),
              ),
            ],
          ),
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
                  title: Text('Offset cost'),
                  subtitle: Text('£0.50'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Average speed'),
                  subtitle: Text('40km/h'),
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
