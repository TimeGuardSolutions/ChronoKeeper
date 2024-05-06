import 'dart:async';
import 'package:flutter/material.dart';

class TrackingFooter extends StatefulWidget {
  const TrackingFooter({super.key});

  @override
  State<TrackingFooter> createState() => _TrackingState();
}

class _TrackingState extends State<TrackingFooter> {
  bool isRunning = false;
  int elapsedSeconds = 0;
  IconData iconData = Icons.play_arrow;

  void _onTrackTime() {
    isRunning = !isRunning;
    if (isRunning) {
      Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          elapsedSeconds = timer.tick ~/ 5;
          iconData = Icons.stop;
          if (!isRunning) {
            timer.cancel();
            iconData = Icons.play_arrow;
          }
        });
      });
    }
  }

  String formatElapsedTime() {
    int elapsedHours = elapsedSeconds ~/ 3600;
    elapsedSeconds %= 3600;
    String hours = elapsedHours < 10 ? '0$elapsedHours' : '$elapsedHours';
    int elapsedMinutes = elapsedSeconds ~/ 60;
    elapsedSeconds %= 60;
    String minutes =
        elapsedMinutes < 10 ? '0$elapsedMinutes' : '$elapsedMinutes';
    String seconds =
        elapsedSeconds < 10 ? '0$elapsedSeconds' : '$elapsedSeconds';
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(formatElapsedTime()),
        Container(
          decoration: const ShapeDecoration(
            color: Colors.orange,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(iconData),
            color: Colors.black,
            onPressed: _onTrackTime,
          ),
        )
      ],
    );
  }
}
