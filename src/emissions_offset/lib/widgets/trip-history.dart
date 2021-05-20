import 'package:emissions_offset/models/trip.dart';
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Historical statistics':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoricalStatistics(),
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
      body: Consumer<TripStore>(
        builder: (context, tripStore, child) => ListView.builder(
          itemCount: tripStore.trips.length,
          itemBuilder: (context, index) {
            var trip = tripStore.trips[index];
            var date = DateFormat.yMd().format(trip.startTime);
            var time = DateFormat.Hm().format(trip.startTime);
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDetail(trip: trip),
                  ),
                );
              },
              leading: Icon(
                Icons.directions_car,
                color: Colors.black54,
              ),
              title: Column(
                children: <Widget>[
                  Text(trip.formatDistance()),
                  Text('Fuel consumed: 0L'),
                  Text('Carbon emitted: 0.0kg'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndRecordTrip(context);
        },
        tooltip: 'New Trip',
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateAndRecordTrip (BuildContext context) async {
    // This will eventually navigate to the new trip page,
    // for now it's adding a placeholder test trip to the trip store.
    var tripStore = context.read<TripStore>();

    //tripStore.addTestTrip();

    var recordedTrip = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripRecord(title: 'Trip Recording'),
      ),
    );

    if(recordedTrip != null){
      setState(() {
        tripStore.addTrip(recordedTrip);
      });

    }


  }
}
