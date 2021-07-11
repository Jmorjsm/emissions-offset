import 'package:emissions_offset/data/trip_formatter.dart';
import 'package:emissions_offset/stores/app_settings_store.dart';
import 'package:emissions_offset/stores/trip_store.dart';
import 'package:emissions_offset/widgets/historical-statistics.dart';
import 'package:emissions_offset/widgets/settings.dart';
import 'package:emissions_offset/widgets/trip-detail.dart';
import 'package:emissions_offset/widgets/trip-record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TripHistory extends StatefulWidget {
  TripHistory({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TripHistoryState createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Historical statistics':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoricalStatistics(
                          allTrips: context.read<TripStore>().trips),
                    ),
                  );
                  break;
                case 'Settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Historical statistics', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Consumer2<TripStore, AppSettingsStore>(
        builder: (context, tripStore, appsettings, child) => Align(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            itemCount: tripStore.trips.length,
            // reverse so trips are displayed in reverse chronological order (newest first)
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var trip = tripStore.trips[index];
              var date = DateFormat.yMd().format(trip.startTime);
              var time = DateFormat.Hm().format(trip.startTime);
              return ListTile(
                onTap: () async {
                  var shouldDelete = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetail(trip: trip),
                    ),
                  );

                  if (shouldDelete) {
                    setState(() {
                      tripStore.deleteTrip(index);
                    });
                  }
                },
                leading: Icon(
                  Icons.directions_car,
                  color: Colors.black54,
                ),
                title: Column(
                  children: <Widget>[
                    Text(TripFormatter.formatDistance(
                        trip.getDistance(), appsettings.appSettings.unit)),
                    Text(
                        'Fuel consumed: ${TripFormatter.FormatFuelConsumed(trip.getFuelConsumed())}'),
                    Text(
                        'Carbon emitted: ${TripFormatter.FormatCarbonEmissions(trip.getCarbonEmissions())}'),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                trailing: Column(
                  children: <Widget>[
                    Text(date),
                    Text(time),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndRecordTrip(context);
        },
        tooltip: 'New Trip',
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateAndRecordTrip(BuildContext context) async {
    var tripStore = context.read<TripStore>();
    var settingsStore = context.read<AppSettingsStore>();

    // This navigates to the trip recording page, awaiting the returned recorded
    // trip.
    var recordedTrip = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripRecord(
            title: 'Trip Recording', appSettings: settingsStore.appSettings),
      ),
    );

    // If a trip was returned, add it to the tripStore retrieved above and
    // update the UI.
    if (recordedTrip != null) {
      if (recordedTrip.tripPoints != null &&
          recordedTrip.getElapsedTime().inSeconds > 0) {
        setState(() {
          tripStore.addTrip(recordedTrip);
        });
      }
    }
  }
}
