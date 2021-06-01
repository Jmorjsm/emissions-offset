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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Column(children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    showDeleteConfirmationDialog(context);
                  },
                  child: Text("Delete all recorded trips"))
            ],
          ),
        ]));
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
        tripStore.storage.clear();
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

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
