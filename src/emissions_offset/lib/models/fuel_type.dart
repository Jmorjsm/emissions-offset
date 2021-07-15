enum FuelType {
  Gasoline,
  Diesel,
}

FuelType fuelTypeFromJson(String fuelTypeAsString) {
  for(FuelType fuelType in FuelType.values) {
    if(fuelType.toString() == fuelTypeAsString) { return fuelType; }
  }

  // Default to gasoline if not found.
  return FuelType.Gasoline;
}
