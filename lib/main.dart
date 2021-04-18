import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suis_je_sam/pages/dashboard.dart';
import 'package:suis_je_sam/pages/help.dart';
import 'package:suis_je_sam/pages/informations.dart';
import 'package:suis_je_sam/pages/splashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences.getInstance().then((prefs) {
    bool ready = prefs.getBool("ready") ?? false;
    if (ready == null) {
      ready = false;
    }
    runApp(MyApp(ready: ready));
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key key, this.ready}) : super(key: key);
  final bool ready;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/splashScreen': (context) => SplashScreen(),
        '/informations': (context) => Informations(),
        '/dashboard': (context) => Dashboard(),
        '/help': (context) => Help()
      },
      debugShowCheckedModeBanner: false,
      title: 'Suis-je Sam ?',
      theme: ThemeData(
          accentColor: Color(0xFFEFEEEE),
          primarySwatch: Colors.blueGrey,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          accentColor: Color(0xFF292D32),
          primarySwatch: Colors.blue,
          brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: (!ready || ready == null) ? SplashScreen() : Dashboard(),
    );
  }
}
