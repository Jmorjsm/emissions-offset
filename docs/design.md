# Design
## Route recording
###  Point
    - double Latitude
    - double Longitude

### TripPoint
    - Point Point
    - DateTime DateTime

### Vehicle
    - double DragCoefficient
    - double Mass

### Trip
    - TripPoint[] TripPoints
    - addPoint(Point)
    - addPosition(Position)
    - double getDistance()
    - double[] getSpeeds()
    - double[] getAccelerations()

### TripRecorder
    - Begin(Trip)
    - Pause(Trip)
    - Resume(Trip)
    - Complete(Trip)
    - registerGpsHandler(Trip)

## MPG calculation
### ConsumptionCalculator
    - ConsumptionCalculator(Vehicle)
    - Calculate(Trip)
    

## Offset calculation
### EmissionsCalculator
    - Calculate(Trip)
    

### OffsetCalculator
    - Calculate(Trip)
    - Calculate(params Trip[])
