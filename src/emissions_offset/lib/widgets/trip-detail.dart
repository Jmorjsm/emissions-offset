import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: Back button
// TODO: Pass through current trip to this page
// TODO: Populate info fields
// TODO: Implement delete
class TripDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Detail'),
      ),
      body: Row(
        children: [
          Column(
            children: [
              Text('Fuel Consumed'),
              Text('1.0L'),
            ],
          ),
          Column(
            children: [
              Column(
                children: [
                  Text('Carbon emitted'),
                  Text('2.3kg'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
