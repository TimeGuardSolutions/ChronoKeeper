import 'package:flutter/material.dart';
import 'home_page.dart';
import 'models/database.dart';

void main() => runApp(const ChronoKeeper());

class ChronoKeeper extends StatelessWidget {
  static const Color mainBackgroundColor = Color.fromRGBO(109, 113, 156, 1.0);
  static const Color secondaryBackgroundColor =
      Color.fromRGBO(67, 83, 122, 1.0);
  static const Color tertiaryBackgroundColor =
      Color.fromRGBO(236, 226, 226, 1.0);
  static const Color complementaryColor = Color.fromRGBO(245, 158, 66, 1.0);

  const ChronoKeeper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChronoKeeper',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: complementaryColor),
        appBarTheme: const AppBarTheme(
            color: secondaryBackgroundColor,
            iconTheme: IconThemeData(color: Colors.white)),
        scaffoldBackgroundColor: mainBackgroundColor,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
