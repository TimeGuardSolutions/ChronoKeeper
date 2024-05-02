import 'package:flutter/material.dart';
import 'package:footer/footer.dart';

class ChronoFooter extends Footer {
  final TimeTracker timeTracker;

  // ignore: use_key_in_widget_constructors
  ChronoFooter(
      {required super.child,
      required this.timeTracker,
      super.backgroundColor = Colors.blue,
      super.alignment = Alignment.center,
      super.padding = const EdgeInsets.all(10.0)});

  static Footer create() {
    final TimeTracker timeTracker = TimeTracker();
    return ChronoFooter(
        timeTracker: timeTracker, child: createChild(timeTracker));
  }

  static Widget createChild(TimeTracker timeTracker) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('HH:MM:SS'),
        Container(
          decoration: const ShapeDecoration(
            color: Colors.orange,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.play_arrow),
            color: Colors.black,
            onPressed: timeTracker.time,
          ),
        )
      ],
    );
  }
}

class TimeTracker {
  final stopwatch = Stopwatch();

  void time() {}
}
