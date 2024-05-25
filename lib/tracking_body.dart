import 'package:chronokeeper/main.dart';
import 'package:chronokeeper/models/model_wrapper.dart';
import 'package:chronokeeper/tracking_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'day_widget.dart';

class TrackingBody extends StatefulWidget {
  final Data data;

  const TrackingBody({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _TrackingBodyState();
}

class _TrackingBodyState extends State<TrackingBody> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: FutureBuilder(
            future: createDayWidgets(),
            builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data ?? [],
                  );
                default:
                  return const Text("Please wait");
              }
            }),
      ))),
      Container(
          color: ChronoKeeper.secondaryBackgroundColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          child: TrackingFooter(data: (widget).data, notifyParent: refresh))
    ]);
  }

  void refresh() {
    setState(() {});
  }

  Future<List<Widget>> createDayWidgets() async {
    final Map<String, List<ProjectsModelWrapper>> dateToProjects =
        await createDateToProjectsMap((widget).data);
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
