import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double currentTx = 0.0;
  double rawTx = 0.0;
  int drinked = 0;
  int userWeight;
  double userGenderTx;
  double cardElevation = 10.0;
  Size mqSize;
  int startDate;
  int currentDate;
  Timer timer;
  bool isEmptyStomach = false;
  int restToDecuve = 0;
  List<dynamic> helps = [ // Liste des textes et images à mettre dans le centre d'aide
    {
      'image': 'images/beer.png',
      'text': 'Une bière de 8°, vous choisissez la quantité ensuite.'
    },
    {'image': 'images/wine.png', 'text': 'Un verre de vin de 14cL à 12°.'},
    {
      'image': 'images/eating.png',
      'text': 'A jeun, la redescente se fait au bout de 30min, contre 60 sinon.'
    },
    {
      'image': 'images/warning.png',
      'text': 'Le taux n\'est qu\'indicatif et ne remplace pas un éthylotest.'
    }
  ];

  // Lors de l'initialisation
  @override
  void initState() {
    super.initState();
    // Récupération des informations dans les shared préférences
    getShared();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => decrementTaux());
  }

  // Lors d'une mise en arrière plan
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
                elevation: cardElevation,
                child: Container(
                    child: MergeSemantics(
                  child: ListTile(
                    title: Text('Je suis à jeun',
                        style: TextStyle(fontSize: 25.0)),
                    trailing: CupertinoSwitch(
                      value: isEmptyStomach,
                      onChanged: (bool value) {
                        setState(() {
                          isEmptyStomach = value;
                          decrementTaux();
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        isEmptyStomach = !isEmptyStomach;
                        decrementTaux();
                      });
                    },
                  ),
                )),
              ),
              Card(
                  shape: roundedShape(),
                  elevation: cardElevation,
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
                        heroTag: "counterBtn",
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
                elevation: cardElevation,
                child: Container(
                  height: mqSize.height / 4,
                  width: mqSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("${currentTx.toStringAsFixed(2)} g/L",
                          style: TextStyle(fontSize: 80)),
                      Center(
                        child: Text(
                          formatRestToDecuve(),
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "helpBtn",
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
      elevation: cardElevation,
      title: Text("Aide", style: TextStyle(fontSize: 35.0)),
      content: Container(
        height: mqSize.height / 2.75,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: helpList())
      ),
      actions: [
        TextButton(
            onPressed: (() => Navigator.pop(context)),
            child: Text("OK", style: TextStyle(fontSize: 20)))
      ],
    );
    showDialog(
      context: context,
      builder: ((BuildContext context) => alert),
    );
  }

  /// Retourne la liste de widgets à mettre dans le centre d'aide
  List<Widget> helpList() {
    List<Widget> rows = [];
    helps.forEach((element) {
      rows.add(Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(element['image'], width: mqSize.width / 8),
              Container(
                  padding: EdgeInsets.only(left: 5.0),
                  width: mqSize.width / 2,
                  child: Text(element['text'], style: TextStyle(fontSize: 18))
              )
            ],
          ),
        ),
      ));
    });
    return rows;
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
      rawTx += (mL * degree * 0.8) / (userWeight * userGenderTx);
      currentTx = rawTx;
      decrementTaux();
    });
  }

  /// Calcul du taux toutes les minutes
  void decrementTaux() {
    if (drinked > 0 && rawTx > 0) {
      setState(() {
        // Récupération du nombre de quarts d'heures en timestamp
        currentDate =
            (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 15).round();

        // La différence de quarts d'heure entre le premier et le dernier verre
        int difference = currentDate - startDate;

        // La descente se fait après :
        // A jeun : 30min
        // Pas à jeun : 60min
        if ((isEmptyStomach == true && difference > 2) ||
            (isEmptyStomach == false && difference > 4)) {
          currentTx = rawTx -
              ((userGenderTx == 0.7) ? 0.025 : 0.02125) *
                  ((currentDate - startDate) -
                      (isEmptyStomach == true ? 2 : 4));
          if (currentTx < 0) {
            currentTx = 0;
          }
        }
        calculRestToDecuve();
      });
    }
  }

  /// Calcul pour savoir 
  void calculRestToDecuve() {
    setState(() {
      restToDecuve = 0;
      double calculTx = currentTx;
      while(calculTx > 0.5) {
        calculTx -= (userGenderTx == 0.7) ? 0.025 : 0.02125;
        restToDecuve++;
      }
      restToDecuve += (isEmptyStomach == true) ? 2 : 4;
    });
  }

  String formatRestToDecuve() {
    if (currentTx == 0) {
      return 'Ajoutez un verre pour commencer';
    }
    if (currentTx <= 0.5) {
      return 'Vous êtes en dessous de la limite';
    }
    int hour = 0;
    int min = 0;
    for(int tmp = restToDecuve; tmp > 0; tmp--) {
      min += 15;
      if (min == 60) {
        hour++;
        min = 0;
      }
    }
    return 'Vous pourrez conduire dans ${hour.toString()}h${min.toString()}';
  }

  /// Affichage du dialog pour choisir la quantité
  void displayDialog() {
    // Création du dialog
    AlertDialog alert = AlertDialog(
        elevation: cardElevation,
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
      currentTx = 0.0;
      rawTx = 0.0;
      restToDecuve = 0;
      drinked = 0;
    });
  }
}
