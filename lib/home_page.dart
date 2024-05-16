import 'package:chronokeeper/chrono_drawer.dart';
import 'package:chronokeeper/models/test_model.dart';
import 'package:chronokeeper/report_body.dart';
import 'package:chronokeeper/ui.dart';
import 'package:flutter/material.dart';
import 'chrono_bar.dart';
import 'tracking_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UI _currentUI = UI.Zeiterfassung;
  final Map<UI, Widget> _uis = {
    UI.Zeiterfassung: const TrackingBody(),
    UI.Bericht: const ReportBody(),
  };

  void _onChangeUI(UI newUI) {
    setState(() {
      _currentUI = newUI;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChronoBar.create(_currentUI.name, context, dummyData),
      body: _uis[_currentUI],
      drawer: ChronoDrawer.create(_currentUI, _onChangeUI, context),
    );
  }
}
