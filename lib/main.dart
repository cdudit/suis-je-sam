import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: 'Vos informations'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double cardElevation = 10.0;
  double userWeight;
  double userHeight;
  int manOrWoman;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: cardElevation,
                child: Container(
                  padding: cardPadding(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: cardPicture('images/man.png', 3),
                        onTap: (() {
                          setState(() {
                            manOrWoman = 0;
                          });
                        }),
                      ),
                      InkWell(
                        child: cardPicture('images/woman.png', 3),
                        onTap: (() {
                          setState(() {
                            manOrWoman = 1;
                          });
                        }),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: cardElevation,
                child: Container(
                  padding: cardPadding(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardPicture('images/weight.png', 4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Slider(
                              value: userWeight ?? 0.0,
                              activeColor: Colors.green,
                              min: 0.0,
                              max: 150.0,
                              divisions: 150,
                              onChanged: ((double d) {
                                setState(() {
                                  userWeight = d;
                                });
                              })),
                          infosResult((userWeight != null) ? userWeight.round().toString() : '0')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: cardElevation,
                child: Container(
                  padding: cardPadding(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardPicture('images/height.png', 4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Slider(
                              value: userHeight ?? 140.0,
                              activeColor: Colors.green,
                              min: 140.0,
                              max: 210.0,
                              divisions: 70,
                              onChanged: ((double d) {
                                setState(() {
                                  userHeight = d;
                                });
                              })),
                          infosResult((userHeight != null) ? userHeight.round().toString() : '140'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Affichage d'une image dans les bonnes dimensions pour l'écran
  Image cardPicture(String path, int divider) {
    return Image.asset(path,
        width: MediaQuery.of(context).size.width / divider,
        fit: BoxFit.cover);
  }

  /// Gestion du padding des cartes
  EdgeInsets cardPadding() {
    return EdgeInsets.only(top: 10.0, bottom: 10.0);
  }

  /// Affichage du titre pour demander une information personnelle
  Text infosTitle(String text) {
    return Text(text, style: TextStyle(fontSize: 40.0));
  }

  /// Affichage du résultat pour afficher le résultat d'un des sliders
  Text infosResult(String text) {
    return Text(text,
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w200));
  }
}
