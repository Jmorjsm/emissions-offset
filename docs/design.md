# Design
## Route recording
###  Point
    - double Latitude
    - double Longitude

### TripPoint
    - Point Point
    - DateTime DateTime

### VehicleClass

### Trip
    - double Distance
    - TripPoint[] TripPoints

### TripRecorder
    - Begin(Trip)
    - Pause(Trip)
    - Resume(Trip)
    - Complete(Trip)
    - registerGpsHandler(Trip)

## MPG calculation
### ConsumptionCalculator
    - Calculate(Trip)
    - Calculate(params Trip[])

## Offset calculation
### EmissionsCalculator
    - Calculate(Trip)
    - Calculate(params Trip[])

### OffsetCalculator
    - Calculate(Trip)
    - Calculate(params Trip[])
