# Todo
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
    - [ ] Trip recording page
    - [ ] Trip summary page
        - This should be the detail page for records in the trip history page table
    - [ ] Trip history page
    - [ ] Last week, month, year, all-time stats page
    - [ ] Settings page?
        - Units (miles/km and currencies)
    - [ ] Warning that the app is for use by passengers

- [ ] Implementation and Testing
    - [ ] Basic app bootstrap and prep for DI, etc.
    - [ ] Basic models (trip, vehicle, point, etc.)
    - [ ] Consumption calculation
        - [ ] ConsumptionCalculationService
            - [ ] Subcomponents of this
            - [ ] Unit tests based on the maths of each component and full end-to-end calculation
    - [ ] Trip recording
        - [ ] Trip service
            - [ ] Simple unit test simulating coordinates
        - [ ] Trip recording page
        - [ ] Trip summary page
