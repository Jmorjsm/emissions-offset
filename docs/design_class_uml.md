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
Trip "1" *-- "1..*" TripPoint
Trip "1" *-- "1" Vehicle
'TODO add TripDetails and TripSummary inheriting from Trip

class TripSummary
TripSummary : double distance
TripSummary : double fuelConsumed
TripSummary : double carbonEmissions
TripSummary : DateTime dateTime
TripSummary <|-- Trip

class TripDetails
TripDetails : Duration duration
TripDetails : double offsetCost
TripDetails : double averageSpeed
TripDetails <|-- TripSummary

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
TripStore : Trip[] GetSavedTrips()

'Fuel Consumption
class ConsumptionCalculator
ConsumptionCalculator : consumptionCalculator(Vehicle)
ConsumptionCalculator : double calculate(Trip)
ConsumptionCalculator : double calculate(params Trip[])
ConsumptionCalculator : double calculateRoadGrade(Point point1, Point point2) {
ConsumptionCalculator : double calculateSpeed(TripPoint tripPoint1, TripPoint tripPoint2) {
ConsumptionCalculator <-- Trip

'Offset calculation
class EmissionsCalculator
EmissionsCalculator : double calculateCarbonEmission(Trip)
EmissionsCalculator : double calculateCarbonEmission(params Trip[])
EmissionsCalculator --> ConsumptionCalculator

class OffsetCalculator
OffsetCalculator : double calculateOffsetCost(Trip)
OffsetCalculator : double calculateOffsetCost(params Trip[])
OffsetCalculator --> EmissionsCalculator


@enduml