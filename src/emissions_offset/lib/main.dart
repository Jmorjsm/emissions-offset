import 'package:emissions_offset/stores/app_settings_store.dart';
import 'package:emissions_offset/stores/trip_store.dart';
import 'package:emissions_offset/widgets/trip-history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TripStore(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppSettingsStore(),
        ),
      ],
      child: EmissionsOffsetApp(),
    ),
  );
}

class EmissionsOffsetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emissions Offset',
      theme: ThemeData(

        primarySwatch: Colors.deepPurple,
        accentColor: Colors.tealAccent,
      ),
      home: TripHistory(title: 'Trip History'),
    );
  }
}
