import 'package:chronokeeper/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'models/model_wrapper.dart';

class ReportBody extends StatefulWidget {
  static const List<Color> colors = [
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.amber
  ];

  final Data data;
  const ReportBody({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => ReportBodyState();
}

class ReportBodyState extends State {
  ProjectsModelWrapper? selectedProject;
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
                FutureBuilder(
                    future: (widget as ReportBody).data.getProjects(),
                    builder: (context,
                        AsyncSnapshot<Iterable<ProjectsModelWrapper>>
                            snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return DropdownMenu<ProjectsModelWrapper>(
                              width: MediaQuery.of(context).size.width -
                                  4 * padding,
                              label: const Text("Projekt"),
                              onSelected: (project) => setState(() {
                                    selectedProject = project;
                                  }),
                              dropdownMenuEntries: (snapshot.data ?? [])
                                  .map((project) =>
                                      DropdownMenuEntry<ProjectsModelWrapper>(
                                          value: project,
                                          label: project.getName()))
                                  .toList());
                        default:
                          return const Text("Please wait");
                      }
                    }),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      child: FutureBuilder(
                          future: showingSections(),
                          builder: (context,
                              AsyncSnapshot<List<PieChartSectionData>>
                                  snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                return PieChart(
                                  PieChartData(
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event,
                                          pieTouchResponse) {
                                        setState(() {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!
                                              .touchedSectionIndex;
                                        });
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 40,
                                    sections: snapshot.data,
                                  ),
                                );
                              default:
                                return const Text("Please wait");
                            }
                          }),
                    ),
                    FutureBuilder(
                        future: createDescriptions(),
                        builder:
                            (context, AsyncSnapshot<List<Widget>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: snapshot.data ?? []);
                            default:
                              return const Text("Please wait");
                          }
                        }),
                    const SizedBox(
                      width: 28,
                    ),
                  ],
                )),
              ]))),
    ]);
  }

  Future<List<Widget>> createDescriptions() async {
    List<Widget> descriptions = [];
    int currentIndex = 0;
    for (TasksModelWrapper task in await selectedProject?.getTasks() ?? []) {
      descriptions.add(Text(
        task.getName(),
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

  Future<List<PieChartSectionData>> showingSections() async {
    final double totalProjectTime =
        (await selectedProject?.getTotalTimeInSeconds())?.toDouble() ?? 0.0;
    int currentIndex = 0;
    List<PieChartSectionData> sections = [];
    for (TasksModelWrapper task in await selectedProject?.getTasks() ?? []) {
      final double totalTaskTime =
          (await task.getTotalTimeInSeconds()).toDouble();
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
