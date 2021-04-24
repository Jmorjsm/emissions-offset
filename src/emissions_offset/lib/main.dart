import 'package:emissions_offset/stores/trip_store.dart';
import 'package:flutter/material.dart';
import 'package:emissions_offset/data/trip_recorder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:provider/provider.dart';
import 'models/trip.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TripStore(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                    leading: Icon(Icons.directions_car),
                    title: Column(
                      children: <Widget>[
                        Text('${trip.getDistance()}km'),
                        Text('Fuel consumed: 0L'),
                        Text('Carbon emitted: 0.0kg'),
                      ],
                    ),
                    trailing: Column(children: <Widget>[
                      Text(date),
                      Text(time),
                    ]),
                  );
                },
              )),
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
