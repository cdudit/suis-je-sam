import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Suis-je Sam ?", style: TextStyle(color: Colors.white))),
      body: Container(
        color: Color.fromRGBO(69, 53, 102, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Surveillez votre taux d'alcoolémie en temps réel",
                style: TextStyle(fontSize: 30, color: Colors.white),
                textAlign: TextAlign.center),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Lottie.asset('images/splash.json'),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  "Activez les notifications pour rester informé même lorsque vous n'êtes pas sur l'application",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                  textAlign: TextAlign.center)
            ),
            Container(
              height: MediaQuery.of(context).size.height / 5,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Lottie.asset('images/notification.json'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setBool('isAlreadyLaunch', true);
            Navigator.pushReplacementNamed(context, '/dashboard');
          });
        }),
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
