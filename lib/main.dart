import 'package:flutter/material.dart';
import 'package:suis_je_sam/pages/dashboard.dart';
import 'package:suis_je_sam/pages/help.dart';
import 'package:suis_je_sam/pages/informations.dart';

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
        '/help': (context) => Help()
      },
      debugShowCheckedModeBanner: false,
      title: 'Suis-je Sam ?',
      theme: ThemeData(
          accentColor: Color(0xFFEFEEEE),
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          accentColor: Color(0xFF292D32),
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: Dashboard(),
    );
  }
}
