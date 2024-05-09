import 'package:chronokeeper/project_widget.dart';
import 'package:flutter/material.dart';

import 'models/test_model.dart';

class DayWidget extends StatefulWidget {
  final String date;
  final List<TestProject> projects;

  const DayWidget({super.key, required this.date, required this.projects});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: createChildren(),
    );
  }

  List<Widget> createChildren() {
    List<Widget> children = [];
    children.add(Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        widget.date,
        style: const TextStyle(color: Colors.white),
      ),
    ));

    for (TestProject project in widget.projects) {
      children.add(ProjectWidget.create(project));
    }
    return children;
  }
}
