import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CarouselController buttonCarouselController = CarouselController();
  List items = [
    {
      'text': "Surveillez votre taux d'alcoolémie en temps réel sans effort",
      'lottie': "images/splash.json",
      'width': 1.0
    },
    {
      'text':
          "Activez les notifications pour savoir quand vous pourrez de nouveau conduire même lorsque vous n'êtes pas sur l'application",
      'lottie': "images/notification.json",
      'width': 0.6
    }
  ];
  bool readyToGo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Suis-je Sam ?", style: TextStyle(color: Colors.white))),
      body: Container(
          color: Color.fromRGBO(69, 53, 102, 1),
          child: Container(
              child: CarouselSlider(
            options: CarouselOptions(
                onPageChanged: (i, reason) {
                  setState(() => readyToGo = (i == items.length - 1));
                },
                enableInfiniteScroll: false,
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1),
            carouselController: buttonCarouselController,
            items: items.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(i['text'],
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                              textAlign: TextAlign.center),
                          Container(
                            width:
                                MediaQuery.of(context).size.width * i['width'],
                            child: Lottie.asset(i['lottie']),
                          ),
                        ],
                      ));
                },
              );
            }).toList(),
          ))),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          buttonCarouselController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.linear);
          if (readyToGo) {
            SharedPreferences.getInstance().then((prefs) {
              prefs.setInt('state', 1);
              Navigator.pushReplacementNamed(context, '/informations');
            });
          }
        }),
        child: Icon((readyToGo) ? Icons.check : Icons.arrow_forward),
      ),
    );
  }
}
