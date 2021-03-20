# Design
## Route recording
###  Point
- float Latitude
- float Longitude

### TripPoint
- Point Point
- DateTime DateTime

### VehicleClass
FYP 

### Trip
- float Distance
- TripPoint[] TripPoints

### TripService
- Begin(Trip)
- Pause(Trip)
- Stop(Trip)
- registerGpsHandler(Trip)

## MPG calculation
### ConsumptionCalculationService
- Calculate(Trip)

## Offset calculation
### EmissionsCalculationService
- Calculate(Trip)

### OffsetCalculationService
- Calculate(params Trip[])
