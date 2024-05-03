import 'package:chronokeeper/tracking_footer.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'day_widget.dart';

class TrackingBody extends StatefulWidget {
  const TrackingBody({super.key});

  @override
  State<StatefulWidget> createState() => _TrackingBodyState();
}

class _TrackingBodyState extends State<TrackingBody> {
  @override
  Widget build(BuildContext context) {
    return FooterView(
        footer: Footer(
            backgroundColor: Colors.blue,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            child: const TrackingFooter()),
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DayWidget(date: 'Heute'),
                DayWidget(date: 'Gestern')
              ],
            ),
          )
        ]);
  }
}
