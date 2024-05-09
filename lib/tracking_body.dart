import 'package:chronokeeper/main.dart';
import 'package:chronokeeper/models/test_model.dart';
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
  final List<TestProject> projects = dummyData;
  final Map<String, List<TestProject>> dateToProjects = createMap(dummyData);

  @override
  Widget build(BuildContext context) {
    return FooterView(
        footer: Footer(
            backgroundColor: ChronoKeeper.secondaryBackgroundColor,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            child: const TrackingFooter()),
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: createDayWidgets(),
            ),
          )
        ]);
  }

  List<Widget> createDayWidgets() {
    List<Widget> widgets = [];
    for (String date in dateToProjects.keys.toList()..sort(sortDate)) {
      widgets.add(DayWidget(
          date: date.toString(), projects: dateToProjects[date] ?? []));
    }
    return widgets;
  }

  int sortDate(String a, String b) {
    return dateToInt(b) - dateToInt(a);
  }

  int dateToInt(String s) {
    int dateValue = int.parse(s.substring(6));
    dateValue *= 100;
    dateValue += int.parse(s.substring(3, 5));
    dateValue *= 100;
    dateValue += int.parse(s.substring(0, 2));
    return dateValue;
  }
}
