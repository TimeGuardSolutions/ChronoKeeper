import 'package:chronokeeper/chrono_footer.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer_view.dart';
import 'day_widget.dart';

class ChronoBody extends StatefulWidget {
  const ChronoBody({super.key});

  @override
  State<StatefulWidget> createState() => _ChronoBodyState();
}

class _ChronoBodyState extends State<ChronoBody> {
  @override
  Widget build(BuildContext context) {
    return FooterView(footer: ChronoFooter.create(), children: const <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
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
