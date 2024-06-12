import 'package:chronokeeper/main.dart';
import 'package:flutter/material.dart';

class DoubleFunctionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DoubleFunctionButton(
      {super.key,
      required this.iconData,
      required this.onTap,
      required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: ChronoKeeper.complementaryColor,
        shape: const CircleBorder(),
        child: InkWell(
            customBorder: const CircleBorder(),
            splashColor: Colors.black12,
            onTap: () => onTap.call(),
            onLongPress: () => onLongPress.call(),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(iconData),
            )));
  }
}
