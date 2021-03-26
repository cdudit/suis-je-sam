import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double taux = 0.0;
  int drinked = 0;
  int userWeight;
  double userGenderTx;
  Size mqSize;
  int startDate;
  int currentDate;
  Timer timer;

  @override
  void initState() {
    super.initState();
    // Récupération des informations dans les shared préférences
    getShared();
    timer = Timer.periodic(
        Duration(seconds: 60), (Timer t) => calculTauxEveryMinute());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mqSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord"),
        actions: [
          IconButton(
              onPressed: (() => refresh()),
              icon: Icon(Icons.refresh, color: Colors.white),
              iconSize: 30),
          IconButton(
              onPressed: (() {
                Navigator.pushNamed(context, '/informations')
                    .then((_) => getShared());
              }),
              icon: Icon(Icons.account_circle, color: Colors.white),
              iconSize: 30)
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                  shape: roundedShape(),
                  elevation: 10.0,
                  child: Column(children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              onTap: (() => displayDialog()),
                              child: Container(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Container(
                                    height: mqSize.height / 6,
                                    width: mqSize.width / 3,
                                    child: Image.asset('images/beer.png')),
                              )),
                          InkWell(
                              onTap: (() => incrementTaux(140, 0.12)),
                              child: Container(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Container(
                                    height: mqSize.height / 6,
                                    width: mqSize.width / 3,
                                    child: Image.asset('images/wine.png')),
                              )),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.9, -1.0),
                      heightFactor: 0.5,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: null,
                        child: Text(drinked.toString(),
                            style: TextStyle(
                                fontSize: 30, color: Colors.grey[800])),
                      ),
                    )
                  ])),
              Card(
                shape: roundedShape(),
                elevation: 10.0,
                child: Container(
                  height: mqSize.height / 3,
                  width: mqSize.width,
                  child: Center(
                    child: Text("${taux.toStringAsFixed(2)} g/L",
                        style: TextStyle(fontSize: 80)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: helpDialog,
        child: Icon(Icons.help, size: 55, color: Colors.white),
      ),
    );
  }

  RoundedRectangleBorder roundedShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));
  }

  void helpDialog() {
    AlertDialog alert = AlertDialog(
        shape: roundedShape(),
        title: Text("Aide", style: TextStyle(fontSize: 35.0)),
        content: Container(
          height: mqSize.height / 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('images/beer.png', width: mqSize.width / 6),
                  Container(
                    width: mqSize.width / 2,
                    child: helpText(
                        'Une bière de 8°, vous choisissez la quantité ensuite.'),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('images/wine.png', width: mqSize.width / 6),
                  Container(
                    width: mqSize.width / 2,
                    child: helpText('Un verre de vin de 14cL à 12°.'),
                  )
                ],
              )
            ],
          ),
        ));
    showDialog(
      context: context,
      builder: ((BuildContext context) => alert),
    );
  }

  /// Retourne le text avec style du centre d'aide
  Text helpText(String data) {
    return Text(data, style: TextStyle(fontSize: 20));
  }

  /// Augmentation du taux d'alcoolémie
  void incrementTaux(int mL, double degree) {
    setState(() {
      if (drinked == 0) {
        // Récupération du timestamp du premier verre bu
        startDate =
            (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 15).round();
      }
      currentDate =
          (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 15).round();

      // Incrémentation du nombre de verres bu
      drinked++;

      // Calcul du taux
      // ((mL * degrés * densité de l'alcool) / (poids * taux)) - (txElimination * (nbQuartHeureMtn-nbQuartHeurePremierVerre))
      taux += ((mL * degree * 0.8) / (userWeight * userGenderTx)) -
          (((userGenderTx == 0.7) ? 0.025 : 0.02125) *
              (currentDate - startDate));
    });
  }

  /// Calcul du taux toutes les minutes
  void calculTauxEveryMinute() {
    if (drinked > 0) {
      setState(() {
        currentDate =
            (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 15).round();
        taux -= ((userGenderTx == 0.7) ? 0.025 : 0.02125) *
            (currentDate - startDate);
      });
    }
  }

  /// Affichage du dialog pour choisir la quantité
  void displayDialog() {
    // Création du dialog
    AlertDialog alert = AlertDialog(
        shape: roundedShape(),
        content: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: (() {
                    incrementTaux(250, 0.08);
                    Navigator.pop(context);
                  }),
                  child: dialogStyle("25cl")),
              TextButton(
                  onPressed: (() {
                    incrementTaux(330, 0.08);
                    Navigator.pop(context);
                  }),
                  child: dialogStyle("33cL")),
              TextButton(
                  onPressed: (() {
                    incrementTaux(500, 0.08);
                    Navigator.pop(context);
                  }),
                  child: dialogStyle("50cL"))
            ],
          ),
        ));
    // Affichage du dialog
    showDialog(
      context: context,
      builder: ((BuildContext context) => alert),
    );
  }

  /// Initialisation des sharedPreferences
  void getShared() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        userWeight = prefs.getInt('userWeight');
        userGenderTx = (prefs.getInt('userGender') == 0) ? 0.7 : 0.6;
      });
    });
  }

  /// Style des button text dans le dialog
  Text dialogStyle(String title) {
    return Text(title, style: TextStyle(fontSize: 35, color: Colors.white));
  }

  /// Remise à zéro
  void refresh() {
    setState(() {
      taux = 0.0;
      drinked = 0;
    });
  }
}
