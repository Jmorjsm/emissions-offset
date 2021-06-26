import 'package:emissions_offset/models/app_settings.dart';
import 'package:emissions_offset/models/fuel_type.dart';
import 'package:emissions_offset/models/unit.dart';
import 'package:emissions_offset/stores/app_settings_store.dart';
import 'package:emissions_offset/stores/trip_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var appSettings;
  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsStore>(
      builder: (context, appSettingsStore, child) {
        appSettings = appSettingsStore.appSettings;
        if (appSettings == null) {
          appSettings = new AppSettings();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => this.saveSettings(context,appSettingsStore),
            ),
          ),
          body: Column(
            children: [
              // Vehicle section
              Row(
                children: [
                  Expanded(
                      child: Text('Vehicle')
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Fuel type:'),
                  ),
                  Expanded(
                    child: _FuelTypeSelect(
                      appSettings: appSettings,
                    ),
                  ),
                ],
              ),

              // Distance unit
              Row(
                children: [
                  Expanded(
                    child: Text('Distance unit:'),
                  ),
                  Expanded(
                    child: _UnitSelect(
                        appSettings: appSettings,
                      ),
                  ),
                ],
              ),
              // Offsetting
              // Offset cost
              Row(
                children: [
                  Expanded(
                    child: Text('Offset cost (£):'),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: appSettingsStore.appSettings.offsetCostPerTonne.toString(),
                      onChanged: (text) {
                        var value = num.tryParse(text);
                        appSettingsStore.appSettings.offsetCostPerTonne = value;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              // Offset multiplier
              Row(
                children: [
                  Expanded(
                    child: Text('Offset multiplier:'),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: appSettingsStore.appSettings.offsetCostMultiplier.toString(),
                      onChanged: (text) {
                        var value = num.tryParse(text);
                        appSettingsStore.appSettings.offsetCostMultiplier = value;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(child:
                    TextButton(
                      onPressed: () {
                        showDeleteConfirmationDialog(context);
                      },
                      child: Text("Delete all recorded trips"))
                  ),
                ],
              ),
            ]
          )
          );
        },
      );
  }

  showDeleteConfirmationDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        // Close the dialog
        Navigator.of(context).pop();
      },
    );

    Widget confirmButton = TextButton(
      child: Text("Delete all trips."),
      onPressed: () {
        // Delete all trips
        var tripStore = context.read<TripStore>();
        setState(() {
          tripStore.clear();
        });
        // Close the dialog
        Navigator.of(context).pop();
      },
    );

    AlertDialog confirmDialog = AlertDialog(
      title: Text("Confirm Delete"),
      content:
          Text("Are you sure you would like to delete all recorded trips?"),
      actions: [cancelButton, confirmButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return confirmDialog;
        });
  }

  saveSettings(BuildContext context, AppSettingsStore appSettingsStore) {
    appSettingsStore.saveSettings(appSettings);
    Navigator.pop(context);
  }
}

class _UnitSelect extends StatefulWidget{

  const _UnitSelect({ this.appSettings });

  final AppSettings appSettings;

  @override
  State<StatefulWidget> createState() => __UnitSelectState();
}

class __UnitSelectState extends State<_UnitSelect> {
  Unit selectedUnit;

  @override
  void initState() {
    super.initState();
    selectedUnit = widget.appSettings.unit;
  }

  @override
  Widget build(BuildContext context) {
    final unitNames = {
      Unit.Kilometers: 'Kilometers',
      Unit.Miles: 'Miles',
    };

    return DropdownButton<Unit>(
      value: selectedUnit,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (unit){
        setState(() {
          selectedUnit = unit;
          widget.appSettings.unit = unit;
        });
      },
      items: <DropdownMenuItem<Unit>>[
        DropdownMenuItem<Unit>(
          value: Unit.Kilometers,
          child: Text(unitNames[Unit.Kilometers]),
        ),
        DropdownMenuItem<Unit>(
          value: Unit.Miles,
          child: Text(unitNames[Unit.Miles]),
        ),
      ],
    );
  }
}

class _FuelTypeSelect extends StatefulWidget{

  const _FuelTypeSelect({ this.appSettings });

  final AppSettings appSettings;

  @override
  State<StatefulWidget> createState() => __FuelTypeSelectState();
}

class __FuelTypeSelectState extends State<_FuelTypeSelect> {
  FuelType selectedFuelType;

  @override
  void initState() {
    super.initState();
    selectedFuelType = widget.appSettings.vehicle.fuelType;
  }

  @override
  Widget build(BuildContext context) {
    final fuelTypeNames = {
      FuelType.Gasoline: 'Gasoline',
      FuelType.Diesel: 'Diesel',
    };

    return DropdownButton<FuelType>(
      value: selectedFuelType,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (fuelType){
        setState(() {
          selectedFuelType = fuelType;
          widget.appSettings.vehicle.fuelType = fuelType;
        });
      },
      items: <DropdownMenuItem<FuelType>>[
        DropdownMenuItem<FuelType>(
          value: FuelType.Gasoline,
          child: Text(fuelTypeNames[FuelType.Gasoline]),
        ),
        DropdownMenuItem<FuelType>(
          value: FuelType.Diesel,
          child: Text(fuelTypeNames[FuelType.Diesel]),
        ),
      ],
    );
  }
}