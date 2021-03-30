import 'dart:async';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suis_je_sam/model/drink.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Variables pour les calculs
  double currentTx = 0.0;
  double rawTx = 0.0;
  int drinked = 0;
  bool isYoung;
  int userWeight;
  double userGenderTx;
  int startDate;
  int currentDate;
  bool isEmptyStomach = false;
  int restToDecuve = 0;

  double beerDegree = 0.06;
  int beerMl = 250;
  double wineDegree = 0.13;
  int wineMl = 140;

  List<Drink> beers = [];
  List<Drink> wines = [];

  // Variables pour le design
  double clayRadius = 20.0;
  double cardElevation = 5.0;
  Color baseColor = Color(0xFF292D32);
  Size mqSize;
  double iconSize = 35.0;

  Timer timer;

  // Liste des textes et images à mettre dans le centre d'aide
  List<dynamic> helps = [
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
      'text': 'Le taux n\'est qu\'indicatif et ne remplace pas un alcootest.'
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
              iconSize: 30),
          IconButton(onPressed: helpDialog, icon: Icon(Icons.help_outline), iconSize: 30)
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClayContainer(
                color: baseColor,
                borderRadius: clayRadius,
                child: MergeSemantics(
                  child: ListTile(
                    title: Text('Je suis à jeun',
                        style: TextStyle(fontSize: 25.0)),
                    trailing: ClayContainer(
                      curveType: CurveType.convex,
                      borderRadius: 75,
                      color: baseColor,
                      child: CupertinoSwitch(
                        value: isEmptyStomach,
                        activeColor: Colors.lightBlue,
                        onChanged: (bool value) {
                          setState(() {
                            isEmptyStomach = value;
                            decrementTaux();
                          });
                        },
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isEmptyStomach = !isEmptyStomach;
                        decrementTaux();
                      });
                    },
                  ),
                ),
              ),
              ClayContainer(
                width: mqSize.width,
                color: baseColor,
                borderRadius: clayRadius,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                          height: mqSize.height / 6,
                          width: mqSize.width / 3,
                          child: Image.asset('images/beer.png')),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClayContainer(
                              color: baseColor,
                                curveType: CurveType.concave,
                                borderRadius: 75.0,
                                child: IconButton(
                                  onPressed: (() => refreshBeers()),
                                  icon: Icon(Icons.refresh),
                                  iconSize: iconSize,
                                )),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text("${beers.length}",
                                  style: TextStyle(fontSize: 30.0)),
                            ),
                            ClayContainer(
                              color: baseColor,
                                curveType: CurveType.convex,
                                borderRadius: 75.0,
                                child: IconButton(
                                    onPressed: (() =>
                                        addDrink(DrinkTitle.beer)),
                                    icon: Icon(Icons.arrow_drop_up),
                                    iconSize: iconSize)),
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClayContainer(
                                  emboss: (beerMl == 250),
                                  curveType: (beerMl == 250)
                                      ? CurveType.concave
                                      : CurveType.convex,
                                  borderRadius: 50.0,
                                  color: baseColor,
                                  child: TextButton(
                                      style: beersMlShape(),
                                      onPressed: (() =>
                                          setState(() => beerMl = 250)),
                                      child: Text("25")),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: ClayContainer(
                                    emboss: (beerMl == 330),
                                    curveType: (beerMl == 330)
                                        ? CurveType.concave
                                        : CurveType.convex,
                                    borderRadius: 50.0,
                                    color: baseColor,
                                    child: TextButton(
                                        style: beersMlShape(),
                                        onPressed: (() =>
                                            setState(() => beerMl = 330)),
                                        child: Text("33")),
                                  ),
                                ),
                                ClayContainer(
                                  emboss: (beerMl == 500),
                                  curveType: (beerMl == 500)
                                      ? CurveType.concave
                                      : CurveType.convex,
                                  borderRadius: 50.0,
                                  color: baseColor,
                                  child: TextButton(
                                      style: beersMlShape(),
                                      onPressed: (() =>
                                          setState(() => beerMl = 500)),
                                      child: Text("50")),
                                )
                              ],
                            ))
                      ],
                    )
                  ],
                ),
              ),
              ClayContainer(
                  width: mqSize.width,
                  color: baseColor,
                  borderRadius: clayRadius,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Container(
                            height: mqSize.height / 6,
                            width: mqSize.width / 3,
                            child: Image.asset('images/wine.png')),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClayContainer(
                              color: baseColor,
                              curveType: CurveType.concave,
                              borderRadius: 75.0,
                              child: IconButton(
                                onPressed: (() => removeDrink(DrinkTitle.wine)),
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: iconSize,
                              )),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text("${wines.length}",
                                style: TextStyle(fontSize: 30.0)),
                          ),
                          ClayContainer(
                              color: baseColor,
                              curveType: CurveType.convex,
                              borderRadius: 75.0,
                              child: IconButton(
                                onPressed: (() => addDrink(DrinkTitle.wine)),
                                icon: Icon(Icons.arrow_drop_up),
                                iconSize: iconSize,
                              )),
                        ],
                      )
                    ],
                  )),
              ClayContainer(
                color: baseColor,
                borderRadius: 20.0,
                child: Container(
                  height: mqSize.height / 4,
                  width: mqSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("${currentTx.toStringAsFixed(2)} g/L*",
                          style: TextStyle(fontSize: 80)),
                      Center(
                        child: Column(children: [
                          Text(formatRestToDecuve(),
                              style: TextStyle(fontSize: 22)),
                          Text(
                            "*Taux indicatif, ne remplace pas un alcootest",
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Ajout d'un verre
  void addDrink(DrinkTitle alcool) {
    switch (alcool) {
      case DrinkTitle.beer:
        setState(() => beers.add(new Drink(degree: beerDegree, ml: beerMl)));
        break;
      case DrinkTitle.wine:
        setState(() => wines.add(new Drink(degree: wineDegree, ml: wineMl)));
        break;
    }
    calculTaux();
  }

  void refreshBeers() {
    if (beers.isNotEmpty) {
      setState(() => beers.clear());
      calculTaux();
    }
  }

  /// Suppression d'un verre
  void removeDrink(DrinkTitle alcool) {
    switch (alcool) {
      case DrinkTitle.beer:
        if (beers.isNotEmpty) {
          setState(() => beers.removeAt(0));
          calculTaux();
        }
        break;
      case DrinkTitle.wine:
        if (wines.isNotEmpty) {
          setState(() => wines.removeAt(0));
          calculTaux();
        }
        break;
    }
    calculTaux();
  }

  /// Augmentation du taux d'alcoolémie
  void calculTaux() {
    setState(() {
      rawTx = 0;
      if ((wines.length + beers.length) == 1) {
        startDate =
            (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 15).round();
      }
      currentDate =
          (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 15).round();

      if (beers.isNotEmpty) {
        beers.forEach((element) {
          rawTx +=
              (element.ml * element.degree * 0.8) / (userWeight * userGenderTx);
        });
      }

      if (wines.isNotEmpty) {
        wines.forEach((element) {
          rawTx +=
              (element.ml * element.degree * 0.8) / (userWeight * userGenderTx);
        });
      }

      currentTx = rawTx;
      decrementTaux();
    });
  }

  /// Calcul du taux toutes les minutes
  void decrementTaux() {
    if ((wines.isNotEmpty || beers.isNotEmpty) && rawTx > 0) {
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
      while (calculTx > (isYoung ? 0.2 : 0.5)) {
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
    if (currentTx <= (isYoung ? 0.2 : 0.5)) {
      return 'Vous êtes en dessous de la limite';
    }
    int hour = 0;
    int min = 0;
    for (int tmp = restToDecuve; tmp > 0; tmp--) {
      min += 15;
      if (min == 60) {
        hour++;
        min = 0;
      }
    }
    return 'Vous pourrez conduire dans ${hour.toString()}h${min.toString()}';
  }

  ButtonStyle beersMlShape() {
    return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    )));
  }

  void helpDialog() {
    AlertDialog alert = AlertDialog(
      elevation: cardElevation,
      title: Text("Aide", style: TextStyle(fontSize: 35.0)),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: helpList()),
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 10.0,
        child: Container(
            padding: EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(element['text'], style: TextStyle(fontSize: 18)),
              leading: Image.asset(element['image'], width: mqSize.width / 10),
            )),
      ));
    });
    return rows;
  }

  /// Initialisation des sharedPreferences
  void getShared() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        userWeight = prefs.getInt('userWeight');
        userGenderTx = (prefs.getInt('userGender') == 0) ? 0.7 : 0.6;
        isYoung = prefs.getBool('isYoung');
      });
    });
  }

  /// Remise à zéro
  void refresh() {
    setState(() {
      currentTx = 0.0;
      rawTx = 0.0;
      restToDecuve = 0;
      beers.clear();
      wines.clear();
    });
  }
}
