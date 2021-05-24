class Vehicle {
  double mass;
  double dragCoefficient;
  Vehicle (double mass, double dragCoefficient){
    this.mass = mass;
    this.dragCoefficient = dragCoefficient;
  }

  Vehicle.fromJson(Map<String, dynamic> json)
    : mass = json['mass'],
      dragCoefficient = json['dragCoefficient'];

  Map<String, dynamic> toJson () => {
    'mass' : mass,
    'dragCoefficient' : dragCoefficient,
  };

}
