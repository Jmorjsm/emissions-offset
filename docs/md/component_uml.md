@startuml

package "models" {
    [Trip]
    [Vehicle]
    [AppSettings]

    [Trip]-->[Vehicle]
    [AppSettings]-->[Vehicle]
}

note top of models
    Classes for basic models of objects that need 
    to be represented and stored in the application.
end note

package "data" {
    [ConsumptionCalculator]
    [TripRecorder]
}

note bottom of data
    Classes for performing calculations using 
    the basic models.
end note

package "widgets" {
    [TripHistory]
    [Settings]
}

note top of widgets
    Classes containing pages code required 
    to render pages and UI components
end note

package "localstorage" {
    [LocalStorage]
}

note bottom of localstorage
    The localstorage flutter plugin
end note

package "geolocator" {
 [Geolocator]
}

note bottom of geolocator
    The geolocator flutter plugin
end note

package "device" {
    [GPS sensor]
    [File system]
}

note bottom of device
    Device-level APIs
end note

package "stores" {
    [TripStore]
    [SettingsStore]
}

note top of stores
    Classes interfacing between the application 
    and the classes provided by localstorage plugin
end note

[Geolocator] --> [GPS sensor]
[LocalStorage] --> [File system]
[Trip] --> [ConsumptionCalculator]
[SettingsStore] --> [LocalStorage]
[TripStore] --> [LocalStorage]
[Settings] --> [AppSettings]
[Settings] --> [SettingsStore]
[TripHistory] --> [Trip]
[TripRecorder] -> [Geolocator]
[TripHistory] -> [TripStore]
[ConsumptionCalculator] -> [Geolocator]


@enduml