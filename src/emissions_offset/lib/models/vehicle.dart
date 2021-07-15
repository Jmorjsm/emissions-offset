import 'package:emissions_offset/models/fuel_type.dart';

class Vehicle {
  double mass;
  double dragCoefficient;
  FuelType fuelType;

  Vehicle (double mass, double dragCoefficient, FuelType fuelType){
    this.mass = mass;
    this.dragCoefficient = dragCoefficient;
    this.fuelType = fuelType;
  }

  Vehicle.fromJson(Map<String, dynamic> json)
    : mass = json['mass'],
      dragCoefficient = json['dragCoefficient'],
      fuelType = fuelTypeFromJson(json['fuelType']);

  Map<String, dynamic> toJson () => {
    'mass' : mass,
    'dragCoefficient' : dragCoefficient,
    'fuelType' : fuelType.toString(),
  };

}
