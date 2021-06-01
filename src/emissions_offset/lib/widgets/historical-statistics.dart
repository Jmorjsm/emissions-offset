import 'package:emissions_offset/data/trip-formatter.dart';
import 'package:emissions_offset/models/trip.dart';
import 'package:emissions_offset/models/unit.dart';
import 'package:emissions_offset/stores/trip_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HistoricalStatistics extends StatefulWidget {
  final allTrips;

  // Initialise this HistoricalStatistics widget with the provided trips.
  const HistoricalStatistics({Key key, this.allTrips}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoricalStatisticsState(allTrips);
}

class HistoricalTotals {
  final FuelConsumed;
  final CarbonEmissions;
  final Distance;
  final AverageSpeed;
  final ElapsedTime;
  final OffsetCost;

  HistoricalTotals(this.FuelConsumed, this.CarbonEmissions, this.Distance, this.AverageSpeed, this.ElapsedTime, this.OffsetCost);

  static HistoricalTotals fromTrips(List<Trip> trips){
    var fuelConsumed = trips.fold(0, (a, b) => a + b.getFuelConsumed());
    var carbonEmissions = trips.fold(0, (a, b) => a + b.getCarbonEmissions());
    var distance = trips.fold(0, (a, b) => a + b.getDistance());

    var averageSpeed = 0;
    if(trips.length > 0) {
       averageSpeed = trips.fold(0, (a, b) => a + b.getAverageSpeed()) /
          trips.length;
    }

    var elapsedTime = trips.fold(0, (a, b) => a + b.getElapsedTime());
    var offsetCost = trips.fold(0, (a, b) => a + b.getOffsetCost());

    return HistoricalTotals(fuelConsumed, carbonEmissions, distance, averageSpeed, elapsedTime, offsetCost);
  }
}

class _HistoricalStatisticsState extends State<HistoricalStatistics>{

  final List<Trip> allTrips;
  final Unit unit = Unit.Kilometers;

  HistoricalTotals totals;

  _HistoricalStatisticsState(this.allTrips){
    totals = HistoricalTotals.fromTrips(allTrips);
  }

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
                  subtitle: Text(TripFormatter.FormatFuelConsumed(totals.FuelConsumed)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Carbon emitted'),
                  subtitle: Text(TripFormatter.FormatCarbonEmissions(totals.CarbonEmissions)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Distance'),
                  subtitle: Text(TripFormatter.formatDistance(totals.Distance, unit)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Time'),
                  subtitle: Text(TripFormatter.formatElapsedTime(totals.ElapsedTime)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Offset cost'),
                  subtitle: Text(TripFormatter.FormatOffsetCost(totals.OffsetCost)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Average speed'),
                  subtitle: Text(TripFormatter.formatAverageSpeed(totals.AverageSpeed, unit)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
