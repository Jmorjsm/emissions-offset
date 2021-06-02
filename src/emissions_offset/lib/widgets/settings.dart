import 'package:emissions_offset/models/app_settings.dart';
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
              Row(
                children: [
                  _UnitSelect(
                    appSettings: appSettings,
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      showDeleteConfirmationDialog(context);
                    },
                    child: Text("Delete all recorded trips"))
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

    return PopupMenuButton<Unit>(
      child: Text(selectedUnit.toString()),
      onSelected: (unit){
        setState(() {
          selectedUnit = unit;
          widget.appSettings.unit = unit;
        });
      },
      itemBuilder: (context) => <PopupMenuItem<Unit>>[
        PopupMenuItem<Unit>(
          value: Unit.Kilometers,
          child: Text(unitNames[Unit.Kilometers]),
        ),
        PopupMenuItem<Unit>(
          value: Unit.Miles,
          child: Text(unitNames[Unit.Miles]),
        ),
      ],
    );
  }
}