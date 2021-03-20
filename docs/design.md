# Design
## Route recording
###  Point
    - float Latitude
    - float Longitude

### TripPoint
    - Point Point
    - DateTime DateTime

### VehicleClass

### Trip
    - float Distance
    - TripPoint[] TripPoints

### TripService
    - Begin(Trip)
    - Pause(Trip)
    - Resume(Trip)
    - Complete(Trip)
    - registerGpsHandler(Trip)

## MPG calculation
### ConsumptionCalculationService
    - Calculate(Trip)
    - Calculate(params Trip[])

## Offset calculation
### EmissionsCalculationService
    - Calculate(Trip)
    - Calculate(params Trip[])

### OffsetCalculationService
    - Calculate(Trip)
    - Calculate(params Trip[])
