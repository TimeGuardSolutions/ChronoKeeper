import 'package:chronokeeper/ui/chrono_drawer.dart';
import 'package:chronokeeper/models/model_wrapper.dart';
import 'package:chronokeeper/ui/report_body.dart';
import 'package:chronokeeper/ui/ui.dart';
import 'package:flutter/material.dart';
import 'chrono_bar.dart';
import 'tracking_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final Data data = Data();
  UI _currentUI = UI.Zeiterfassung;
  final Map<UI, Widget> _uis = {
    UI.Zeiterfassung: TrackingBody(data: data),
    UI.Bericht: ReportBody(data: data),
  };

  void _onChangeUI(UI newUI) {
    setState(() {
      _currentUI = newUI;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChronoBar.create(_currentUI.name, context, data),
      body: _uis[_currentUI],
      drawer: ChronoDrawer.create(_currentUI, _onChangeUI, context),
    );
  }
}
