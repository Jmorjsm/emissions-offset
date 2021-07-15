@startuml
'Basic models
class Point
Point : double latitude
Point : double longitude
Point : double altitude

class TripPoint
TripPoint : Point point
TripPoint : DateTime dateTime
TripPoint "1" *-- "1" Point

class Vehicle
Vehicle : double dragCoefficient
Vehicle : double mass

class Trip
Trip : TripPoint[] tripPoints
Trip : addPoint(Point)
Trip : double getDistance()
Trip : double[] getSpeeds()
Trip : double[] getAccelerations()
Trip : double distance
Trip : double fuelConsumed
Trip : double carbonEmissions
Trip : double offsetCost
Trip : double averageSpeed
Trip : DateTime startDateTime
Trip : DateTime endDateTime
Trip : Vehicle vehicle

Trip "1" *-- "1..*" TripPoint
Trip "1" *-- "1" Vehicle

'Trip recording
class TripRecorder
TripRecorder : begin(Trip)
TripRecorder : pause(Trip)
TripRecorder : resume(Trip)
TripRecorder : complete(Trip)
TripRecorder : registerGpsHandler(Trip)
TripRecorder --> Trip
TripRecorder <-- Geolocator

class Geolocator
note "This is part of the geolocator package" as NGeolocator1
Geolocator .. NGeolocator1

class TripStore
TripStore : save(Trip)
TripStore : Trip[] loadTrips()

'Fuel Consumption
class ConsumptionCalculator
ConsumptionCalculator : consumptionCalculator(Vehicle)
ConsumptionCalculator : double calculate(Trip)
ConsumptionCalculator : double calculateRoadGrade(Point point1, Point point2) {
ConsumptionCalculator : double calculateSpeed(TripPoint tripPoint1, TripPoint tripPoint2) {
ConsumptionCalculator <-- Trip

'Offset calculation
class EmissionsCalculator
EmissionsCalculator : double calculate(Trip)
EmissionsCalculator --> ConsumptionCalculator

class OffsetCalculator
OffsetCalculator : double calculate(Trip)
OffsetCalculator --> EmissionsCalculator

@enduml