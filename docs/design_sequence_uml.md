## Trip Recording sequence diagram.
@startuml
actor user as user
entity trip as trip
boundary tripHistory as tripHistory
boundary tripRecord as tripRecord
control consumptionCalculator as consumptionCalculator
control tripRecorder as tripRecorder
database tripStore as tripStore

user -> tripHistory : Click new trip
tripHistory -> tripRecord : navigate to
user -> tripRecord : Click start recording
tripRecord -> trip : create new trip
tripRecord -> tripRecorder : registerGpsHandler(trip)
tripRecorder -> trip : add TripPoint
user -> tripRecord : Click pause recording
tripRecord -> trip : pause trip
user -> tripRecord : Click resume recording
tripRecord -> trip : resume trip
user -> tripRecord : Click back (complete)
tripRecord -> trip : end trip
trip -> trip : getAverageSpeed()
trip -> consumptionCalculator : calculate()
trip -> trip : get Emissions and cost
tripRecord -> tripHistory : navigate to trip history, passing back the trip.
tripHistory -> tripStore : addTrip(trip)
tripHistory -> user : display the recorded trip in the trip list.
@enduml