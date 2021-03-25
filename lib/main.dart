import 'package:flutter/material.dart';
import 'package:suis_je_sam/pages/dashboard.dart';
import 'package:suis_je_sam/pages/informations.dart';
import 'package:suis_je_sam/tools/sharedTools.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/informations': (context) => Informations(),
        '/dashboard': (context) => Dashboard(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Suis-je Sam ?',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Dashboard()
    );
  }
}
