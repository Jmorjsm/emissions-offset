class ConsumptionCalculator {
  consumptionCalculator(Vehicle vehicle) {
    this.vehicle = vehicle;
  }

  double calculate(Trip trip) {
    var mpgValues = [];
    var accelerations = trip.getAccelerations();
    for (var pointIndex = 1; pointIndex < trip.tripPoints.length; pointIndex++){
      var p1 = trip.tripPoints[pointIndex-1];
      var p2 = trip.tripPoints[pointIndex]

      // get the input parameters for the numerator
      var k1 = this.vehicle.mass;

      // get the input parameters for the denominator
      var a = accelerations[pointIndex];
      var k2 = this.calculateRoadGrade(p1.point,p2.point);
      var k3 = this.vehicle.dragCoefficient;
      var vs = this.calculateSpeed(p1, p2);
      
      // calculate this denonminator
      var denominator = a + k2 + (k3 * (vs*vs))
      
      // calculate this mpg value and add to the ongoing values list
      mpgValues.add(k1/denonminator);
    }

    var sumMpg = mpgValues.reduce((a,b) => a+b);
    var avgMpg = sumMpg / mpgValues.length;

    return avgMpg * trip.getDistance();
  }

  double calculate(Trip[] trips) {
    var total = 0;
    for(var tripIndex = 0; tripIndex < trips.length; tripIndex++) {
      total += this.calculate(trips[tripIndex]);
    }
  }
  
  double calculateRoadGrade(Point point1, Point point2) {
    var deltaAltitude = point2.altitude - point1.altitude;
    var distance = Geolocator.distanceBetween(point2.latitude, point2.longitude,
      point1.latitude,point1.longitude);
    
    return deltaAltitude / distance;
  }

  double calculateSpeed(TripPoint tripPoint1, TripPoint tripPoint2) {
    var point1 = tripPoint1.point;
    var point2 = tripPoint2.point;

    var distance = Geolocator.distanceBetween(point2.latitude, point2.longitude,
      point1.latitude,point1.longitude);
    var deltaTime = tripPoint2.dateTime - tripPoint1.dateTime;

    return distance / deltaTime;
  }
}