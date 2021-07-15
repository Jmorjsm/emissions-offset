enum Unit {
  Miles,
  Kilometers
}

Unit unitFromJson(String unitAsString) {
  for(Unit unit in Unit.values) {
    if(unit.toString() == unitAsString) { return unit; }
  }

  // Default to km if not found.
  return Unit.Kilometers;
}
