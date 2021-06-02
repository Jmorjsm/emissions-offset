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
  final Duration ElapsedTime;
  final OffsetCost;

  HistoricalTotals(this.FuelConsumed, this.CarbonEmissions, this.Distance, this.AverageSpeed, this.ElapsedTime, this.OffsetCost);

  static HistoricalTotals fromTrips(List<Trip> trips){
    var fuelConsumed = trips.fold(0, (a, b) => a + b.getFuelConsumed());
    var carbonEmissions = trips.fold(0, (a, b) => a + b.getCarbonEmissions());
    num distance = trips.fold(0, (a, b) => a + b.getDistance());

    num averageSpeed;
    if(trips.length > 0) {
      num totalAvgSpeed = trips.fold(0, (a, b) => a + b.getAverageSpeed());
       averageSpeed =  totalAvgSpeed / trips.length;
    }
    else {
      averageSpeed = 0;
    }

    Duration elapsedTime = trips.fold(Duration.zero, (a, b) => a + b.getElapsedTime());
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
        title: Text('Historical statistics'),
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
      floatingActionButton: FloatingActionButton(
        // TODO: Try and get the position here
        onPressed: () {
          showFilterOptions(context);
        },
        tooltip: 'Filter',
        child: Icon(Icons.filter_alt),
      )
    );
  }

  void showFilterOptions(BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0.0, 0.0, 25.0, 25.0),
      items: {'Last week', 'Last month', 'Last year', 'All time'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList()
        ).then((value) {
      filterAndCalculateTotals(context, value);
    });
  }

  void filterAndCalculateTotals(BuildContext context, String value) {
    List<Trip> tripsInRange;
    switch(value){
      case 'Last week':
        tripsInRange = this.allTrips.where((element) => element.endTime.isAfter(DateTime.now().subtract(Duration(days: 7)))).toList();
        break;
      case 'Last month':
        tripsInRange = this.allTrips.where((element) => element.endTime.isAfter(DateTime.now().subtract(Duration(days: 30)))).toList();
        break;
      case 'Last year':
        tripsInRange = this.allTrips.where((element) => element.endTime.isAfter(DateTime.now().subtract(Duration(days: 365)))).toList();
        break;
      case 'All time':
        tripsInRange = this.allTrips;
        break;
    }

    setState(() {
      totals = totals = HistoricalTotals.fromTrips(tripsInRange);
    });
  }
}
