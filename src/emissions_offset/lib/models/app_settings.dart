import 'dart:convert';

import 'package:emissions_offset/models/unit.dart';
import 'package:emissions_offset/models/vehicle.dart';

class AppSettings {
  num offsetCostPerTonne;
  num offsetCostMultiplier;
  Unit unit;
  Vehicle vehicle;

  // Constructor with default settings.
  AppSettings(){
    // Average offset cost per tonne = £10
    this.offsetCostPerTonne = 10;
    this.offsetCostMultiplier = 1;
    this.unit = Unit.Kilometers;
    this.vehicle = new Vehicle(1500, 0.3);
  }

  // Deserialise from json
  AppSettings.fromJson(Map<String, dynamic> jsonMap)
      : offsetCostPerTonne = jsonMap['offsetCostPerTonne'],
        offsetCostMultiplier = jsonMap['offsetCostMultiplier'],
        unit = unitFromJson(jsonMap['unit']),
        vehicle = Vehicle.fromJson(json.decode(jsonMap['vehicle']));

  // Serialise to json
  Map<String, dynamic> toJson() => {
    'offsetCostPerTonne': offsetCostPerTonne,
    'offsetCostMultiplier': offsetCostMultiplier,
    'unit': unit.toString(),
    'vehicle': jsonEncode(vehicle),
  };
}