# Todo
## Implementation
- [x] Disable saving on not-started trips
- [x] Fix distance recording
- [ ] Warning that the app is for use by passengers only
- [ ] Trip delete
- [x] Trip history
    - [x] Fix averages
    - [x] Show carbon emissions and offset costs in trip details
- [x] Historical statistics view
    - [x] Filtering
    - [ ] Ensure we can calculate all the stats fine
    - [x] Test
- [ ] Settings
    - [ ] List of vehicles/some way to input weight, drag coefficient, fuel type
    - [x] Units selection
    - [x] Offset multiplier
    - [x] Clear history option - https://pub.dev/documentation/localstorage/latest/localstorage/LocalStorage/clear.html
        - [ ] Write about needing this in report
        - [x] Confirmation dialog - https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-in-flutter

## Report
- [ ] Scaffold
- [ ] Show in methods part about experiments with flutter and geolocation.
- [ ] Problem of recording gps requiring foreground
- [ ] Problem of hanging when completing
## General
- [ ] Document fuel consumption methods
    - [ ] Read related papers
    - [ ] What components do we need to calculate
    - [ ] Calculating acceleration and various other secondary stats from gps
    - [ ] How do we calculate these from the variables we have?
    - [ ] How do we calculate the final fuel consumption value?

- [ ] Document Route recording 

- [ ] Document fuel consumption to carbon emissions calculations
    - [ ] Find source for this
    - [ ] What parameters from the fuel consumption do we need and do we just multiply by the distance?
    - [ ] Document how this fits into the app?
    - [ ] How to convert emissions to offset?

- [ ] Design of app UI
    - [x] Trip recording page
    - [x] Trip summary page
        - [x] This should be the detail page for records in the trip history page table
    - [x] Trip history page
    - [ ] Last week, month, year, all-time stats page
    - [ ] Settings page?
        - Units (miles/km and currencies)
    - [ ] Warning that the app is for use by passengers

- [ ] Implementation and Testing
    - [x] Basic app bootstrap and prep for DI, etc.
    - [x] Basic models (trip, vehicle, point, etc.)
    - [x] Consumption calculation
        - [x] ConsumptionCalculationService
            - [x] Subcomponents of this
            - [x] Unit tests based on the maths of each component and full end-to-end calculation
    - [x] Trip recording
        - [x] Trip ~~service~~ Store
            - [x] Simple unit test simulating coordinates
        - [x] Trip recording page
        - [x] Trip summary page
