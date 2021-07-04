# Examples of serialised json
## tripstore.trips with two trips
```json
[
    {
        "tripPoints":"[]",
        "startTime":"2021-05-01 17:50:55.138335",
        "endTime":"2021-05-01 17:51:01.136603",
        "_distanceCache":0,
        "_fuelConsumed":1333.2672571718808,
        "_carbonEmissions":3066.5146914953257,
        "_offsetCost":0.0,
        "_averageSpeed":3.2193661248494245,
        "vehicle":"{\"mass\":750.0,\"dragCoefficient\":0.3,\"fuelType\":\"FuelType.Gasoline\"}"
    },
    {
        "tripPoints":"[]",
        "startTime":"2021-05-01 18:49:07.214375",
        "endTime":"2021-05-01 18:59:47.660095",
        "_distanceCache":0.88,
        "_fuelConsumed":-687.5199747110321,
        "_carbonEmissions":-1581.2959418353737,
        "_offsetCost":-790.6479709176868,
        "_averageSpeed":138.3631073259439,
        "vehicle":"{\"mass\":750.0,\"dragCoefficient\":0.3,\"fuelType\":\"FuelType.Gasoline\"}"
    },
]
```
## appsettings
```json
{
    "offsetCostPerTonne": 10,
    "offsetCostMultiplier": 1,
    "unit": "Unit.Miles", 
    "vehicle": {
        "mass":1500.0,
        "dragCoefficient":0.3,
        "fuelType":"FuelType.Gasoline"
        }
    }
```