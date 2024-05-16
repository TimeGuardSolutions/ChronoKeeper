import 'package:chronokeeper/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'models/test_model.dart';

class ReportBody extends StatefulWidget {
  static const List<Color> colors = [
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.amber
  ];

  const ReportBody({super.key});

  @override
  State<StatefulWidget> createState() => ReportBodyState();
}

class ReportBodyState extends State {
  final List<TestProject> projects = dummyData;
  TestProject? selectedProject;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    const double padding = 10.0;
    return ListView(padding: const EdgeInsets.all(padding), children: [
      Container(
          padding: const EdgeInsets.all(padding),
          decoration: const BoxDecoration(
              color: ChronoKeeper.tertiaryBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: AspectRatio(
              aspectRatio: 1.3,
              child: Column(children: [
                DropdownMenu<TestProject>(
                    width: MediaQuery.of(context).size.width - 4 * padding,
                    label: const Text("Projekt"),
                    onSelected: (project) => setState(() {
                          selectedProject = project;
                        }),
                    dropdownMenuEntries: projects
                        .map((project) => DropdownMenuEntry<TestProject>(
                            value: project, label: project.name))
                        .toList()),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: createDescriptions()),
                    const SizedBox(
                      width: 28,
                    ),
                  ],
                )),
              ]))),
    ]);
  }

  List<Widget> createDescriptions() {
    List<Widget> descriptions = [];
    int currentIndex = 0;
    for (TestTask task in selectedProject?.tasks ?? []) {
      descriptions.add(Text(
        task.name,
        style: TextStyle(
            color: ReportBody.colors[currentIndex++ % ReportBody.colors.length],
            fontWeight: FontWeight.bold),
      ));
      descriptions.add(const SizedBox(
        height: 4,
      ));
    }
    descriptions.add(const SizedBox(
      height: 14,
    ));
    return descriptions;
  }

  List<PieChartSectionData> showingSections() {
    final double totalProjectTime =
        selectedProject?.getTotalTimeInSeconds().toDouble() ?? 0.0;
    int currentIndex = 0;
    List<PieChartSectionData> sections = [];
    for (TestTask task in selectedProject?.tasks ?? []) {
      final double totalTaskTime = task.getTotalTimeInSeconds().toDouble();
      sections.add(PieChartSectionData(
          color: ReportBody.colors[currentIndex % ReportBody.colors.length],
          value: totalTaskTime,
          title:
              "${(totalTaskTime / totalProjectTime * 100).toStringAsFixed(2)}%",
          titleStyle: TextStyle(
              fontSize: (currentIndex == touchedIndex ? 25.0 : 16.0),
              fontWeight: FontWeight.bold),
          radius: (currentIndex == touchedIndex ? 60.0 : 50.0)));
      ++currentIndex;
    }
    return sections;
  }
}
