enum Unit {
  Miles,
  Kilometers
}

Unit unitFromJson(String unitAsString){
  for(Unit unit in Unit.values){
    if(unit.toString() == unitAsString) { return unit;}
  }

  return null;
}
