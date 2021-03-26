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

  @override
  void initState() {
    super.initState();
    // Récupération des informations dans les shared préférences
    getShared();
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
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
                                fontSize: 30,
                                color: Colors.grey[800])),
                      ),
                    )
                  ])),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
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
    );
  }

  /// Augmentation du taux d'alcoolémie
  void incrementTaux(int mL, double degree) {
    setState(() {
      drinked++;
      // (mL * degrés * densité de l'alcool) / (poids * taux)
      taux += (mL * degree * 0.8) / (userWeight * userGenderTx);
    });
  }

  /// Affichage du dialog pour choisir la quantité
  void displayDialog() {
    // Création du dialog
    AlertDialog alert = AlertDialog(
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
