import 'package:chronokeeper/ui.dart';
import 'package:flutter/material.dart';

class ChronoDrawer extends Drawer {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  const ChronoDrawer({super.key, required super.child});

  static Drawer create(
      UI currentUI, Function(UI) onChangeUI, BuildContext context) {
    Widget child = createChild(currentUI, onChangeUI, context);
    return ChronoDrawer(child: child);
  }

  static Widget createChild(
      UI currentUI, Function(UI) onChangeUI, BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: createOptions(currentUI, onChangeUI, context),
    );
  }

  static List<Widget> createOptions(
      UI currentUI, Function(UI) onChangeUI, BuildContext context) {
    List<Widget> options = [];
    for (var ui in UI.values) {
      options.add(ListTile(
        title: Text(ui.name),
        selected: ui.index == currentUI.index,
        onTap: () {
          onChangeUI(ui);
          Navigator.pop(context);
        },
      ));
    }
    return options;
  }
}
