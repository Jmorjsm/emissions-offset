# Examples of serialised json
## tripstore.trips with two trips
```json
[
    {
        "tripPoints":"[]",
        "startTime":"2021-05-01 17:50:55.138335",
        "endTime":"2021-05-01 17:51:01.136603",
        "_distanceCache":0,
        "_fuelConsumed":0,
        "_carbonEmissions":0,
        "_offsetCost":0.0,
        "_averageSpeed":0,
        "vehicle":"{\"mass\":750.0,\"dragCoefficient\":0.3,\"fuelType\":\"FuelType.Gasoline\"}"
    },
    {
        "tripPoints":"[]",
        "startTime":"2021-05-01 18:49:07.214375",
        "endTime":"2021-05-01 18:59:47.660095",
        "_distanceCache":0,
        "_fuelConsumed":0,
        "_carbonEmissions":0,
        "_offsetCost":0.0,
        "_averageSpeed":0,
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