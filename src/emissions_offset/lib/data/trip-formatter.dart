import 'package:emissions_offset/models/unit.dart';
import 'package:intl/intl.dart';

class TripFormatter {
  static String formatDistance(num distance, Unit unit) {
    var distanceDenominator;
    switch(unit){
      case Unit.Miles:
        distanceDenominator = 1609.34;
        break;
      case Unit.Kilometers:
        distanceDenominator = 1000;
        break;
    }

    return '${NumberFormat("##00.00").format(distance/distanceDenominator)}${formatDistanceUnit(unit)}';
  }

  static String formatDistanceUnit(Unit unit){
    switch (unit){
      case Unit.Miles:
        return "miles";
        break;
      case Unit.Kilometers:
        return "km";
        break;
    }
  }

  static String formatSpeedUnit(Unit unit){
    switch (unit){
      case Unit.Miles:
        return "mph";
        break;
      case Unit.Kilometers:
        return "kph";
        break;
    }
  }

  static String formatElapsedTime(Duration elapsedTime) {
    return '${elapsedTime.inHours.toString().padLeft(2, "0")}:${elapsedTime.inMinutes.remainder(60).toString().padLeft(2, "0")}:${elapsedTime.inSeconds.remainder(60).toString().padLeft(2, "0")}';
  }

  static String formatAverageSpeed(num speedInMetersPerSecond, Unit unit) {
    const num secondsPerHour = 60*60;
    var unitMultiplier;
    switch(unit){
      case Unit.Miles:
        unitMultiplier = secondsPerHour / 1609.34;
        break;
      case Unit.Kilometers:
        unitMultiplier = secondsPerHour / 1000;
        break;
    }

    return '${NumberFormat("##00.00").format(speedInMetersPerSecond*unitMultiplier)}${TripFormatter.formatSpeedUnit(unit)}';
  }

  static String FormatFuelConsumed(num fuelConsumed) {
    return '${NumberFormat("##00.00").format(fuelConsumed)}L';
  }

  static String FormatCarbonEmissions(num carbonEmitted) {
    return '${NumberFormat("##00.00").format(carbonEmitted)}kg';
  }

  static String FormatOffsetCost(num offsetCost) {
    return '${NumberFormat("£##00.00").format(offsetCost)}';
  }
}