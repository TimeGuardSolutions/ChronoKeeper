import 'package:flutter/material.dart';

class DayWidget extends StatelessWidget {
  final String date;

  const DayWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              date,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Card(
            color: Colors.white70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(title: Text('Section'), subtitle: Text('Project xy')),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Beschreibung'),
                        Text('HH:MM:SS')
                      ],
                    ))
              ],
            ),
          ),
        ]);
  }
}
