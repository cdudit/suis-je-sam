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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    bool needSplashScreen = true;
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('isAlreadyLaunch')) {
        needSplashScreen = false;
      }
    });

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
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          accentColor: Color(0xFF292D32),
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: (needSplashScreen) ? SplashScreen() : Dashboard(),
    );
  }
}
