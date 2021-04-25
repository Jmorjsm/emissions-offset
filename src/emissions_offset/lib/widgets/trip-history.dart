import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/stores/trip_store.dart';
import 'package:emissions_offset/widgets/trip-detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TripHistory extends StatefulWidget {
  TripHistory({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
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
          // This will eventually navigate to the new trip page,
          // for now it's adding a placeholder test trip to the trip store.
          var tripStore = context.read<TripStore>();
          tripStore.addTestTrip();
        },
        tooltip: 'New Trip',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
