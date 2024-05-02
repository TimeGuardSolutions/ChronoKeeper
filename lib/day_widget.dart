import 'package:flutter/material.dart';

class DayWidget extends StatelessWidget {
  final String date;

  const DayWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            date,
            style: const TextStyle(color: Colors.white),
          ),
          Container(
            color: Colors.grey,
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 20.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Section', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Project xy'),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('Beschreibung'), Text('HH:MM:SS')],
                )
              ],
            ),
          ),
        ]);
  }
}
