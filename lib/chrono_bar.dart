import 'package:flutter/material.dart';

class ChronoBar extends AppBar {
  ChronoBar({
    super.key,
    required Text super.title,
  }) : super(
          centerTitle: true,
          elevation: 0.0,
        );

  static AppBar build(String title) {
    return ChronoBar(
        title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ));
  }
}
