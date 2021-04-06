import 'dart:async';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suis_je_sam/model/drink.dart';
import 'package:suis_je_sam/tools/globals.dart' as globals;
import 'package:suis_je_sam/tools/notifications.dart';

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
  int hourOfDecuve;

  double beerDegree = globals.beerDegree;
  int beerMl = 250;
  double wineDegree = globals.wineDegree;
  int wineMl = globals.wineMl;
  double whiskyDegree = globals.whiskyDegree;
  int whiskyMl = globals.whiskyMl;

  List<Drink> beers = [];
  List<Drink> wines = [];
  List<Drink> whiskies = [];

  // Variables pour le design
  double clayRadius = globals.clayRadius;
  Color baseColor;
  Size mqSize;
  double iconSize = 35.0;

  Timer timer;
  NotificationPlugin notificationPlugin;

  // Lors de l'initialisation
  @override
  void initState() {
    super.initState();
    // Récupération des informations dans les shared préférences
    getShared();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => decrementTaux());
    notificationPlugin = new NotificationPlugin();
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
    baseColor = Theme.of(context).accentColor;

    return Scaffold(
      drawer: Drawer(
        child: Container(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                  child: Text("Suis-je Sam ?", style: TextStyle(fontSize: 35))),
              margin: EdgeInsets.only(bottom: 2.0),
            ),
            ListTile(
              title: Text("Mes informations", style: TextStyle(fontSize: 20)),
              leading: Icon(Icons.account_circle, size: 30),
              onTap: (() {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/informations')
                    .then((_) => getShared());
              }),
            ),
            ListTile(
              title: Text("Aide", style: TextStyle(fontSize: 20)),
              leading: Icon(Icons.help, size: 30),
              onTap: (() {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/help');
              }),
            )
          ],
        )),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Tableau de bord", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: (() => refresh()),
              icon: Icon(Icons.refresh),
              iconSize: 30),
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
                        style: Theme.of(context).textTheme.headline5),
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
                    drinkContainer('images/beer.png'),
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
                                  onPressed: (() =>
                                      removeDrink(DrinkTitle.beer)),
                                  icon: Icon(Icons.refresh),
                                  iconSize: iconSize,
                                )),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text("${beers.length}",
                                  style: Theme.of(context).textTheme.headline4),
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
                            padding: EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                beerMlContainer(250),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  child: beerMlContainer(330)),
                                beerMlContainer(500),
                              ],
                            ))
                      ],
                    )
                  ],
                ),
              ),
              myAlcool('images/wine.png', DrinkTitle.wine, wines),
              myAlcool('images/whisky.png', DrinkTitle.whisky, whiskies),
              ClayContainer(
                color: baseColor,
                borderRadius: 20.0,
                child: Container(
                  height: mqSize.height / 4.5,
                  width: mqSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("${currentTx.toStringAsFixed(2)} g/L*",
                          style: TextStyle(fontSize: 70)),
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

  ClayContainer beerMlContainer(int ml) {
    return ClayContainer(
        emboss: (beerMl == ml),
        curveType: (beerMl == ml) ? CurveType.concave : CurveType.none,
        spread: (beerMl == ml) ? 10 : 0,
        depth: (beerMl == ml) ? 10 : 0,
        borderRadius: 50.0,
        color: baseColor,
        child: TextButton(
            style: beersMlShape(),
            onPressed: (() => setState(() => beerMl = ml)),
            child: Text("${(ml / 10).round()}", style: TextStyle(fontSize: 20))));
  }

  ClayContainer myAlcool(
      String imgPath, DrinkTitle drinkTitle, List<Drink> list) {
    return ClayContainer(
        width: mqSize.width,
        color: baseColor,
        borderRadius: clayRadius,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          drinkContainer(imgPath),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ClayContainer(
                color: baseColor,
                curveType: CurveType.concave,
                borderRadius: 75.0,
                child: IconButton(
                  onPressed: (() => removeDrink(drinkTitle)),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: iconSize,
                )),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Text("${list.length}",
                    style: Theme.of(context).textTheme.headline4)),
            ClayContainer(
                color: baseColor,
                curveType: CurveType.convex,
                borderRadius: 75.0,
                child: IconButton(
                  onPressed: (() => addDrink(drinkTitle)),
                  icon: Icon(Icons.arrow_drop_up),
                  iconSize: iconSize,
                ))
          ])
        ]));
  }

  Container drinkContainer(String path) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          width: mqSize.width / 4,
          child: Image.asset(path)),
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
      case DrinkTitle.whisky:
        setState(
            () => whiskies.add(new Drink(degree: whiskyDegree, ml: whiskyMl)));
        break;
    }
    calculTaux();
  }

  /// Suppression d'un verre
  void removeDrink(DrinkTitle drinkTitle) {
    switch (drinkTitle) {
      case DrinkTitle.beer:
        if (beers.isNotEmpty) {
          setState(() => beers.clear());
        }
        break;
      case DrinkTitle.wine:
        if (wines.isNotEmpty) {
          setState(() => wines.removeAt(0));
        }
        break;
      case DrinkTitle.whisky:
        if (whiskies.isNotEmpty) {
          setState(() => whiskies.removeAt(0));
        }
        break;
    }
    calculTaux();
  }

  /// Augmentation du taux d'alcoolémie
  void calculTaux() {
    setState(() {
      rawTx = 0;
      if ((wines.length + beers.length + whiskies.length) == 1) {
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

      if (whiskies.isNotEmpty) {
        whiskies.forEach((element) {
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
              ((userGenderTx == 0.7) ? 0.03125 : 0.024375) *
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

  /// Calcul pour savoir combien de temps il reste avant de descendre sous la limite
  void calculRestToDecuve() {
    setState(() {
      restToDecuve = 0;
      double tmp = currentTx;
      while (tmp > (isYoung ? 0.2 : 0.5)) {
        tmp -= (userGenderTx == 0.7) ? 0.03125 : 0.024375;
        restToDecuve++;
      }
      restToDecuve += (isEmptyStomach == true) ? 2 : 4;
      hourOfDecuve = DateTime.now().millisecondsSinceEpoch +
          (restToDecuve * 15 * 60 * 1000);
      if (currentTx > (isYoung ? 0.2 : 0.5)) {
        notificationPlugin.showNotification(hourOfDecuve);
      }
    });
  }

  /// Retourne le texte signifiant dans combien de temps l'utilisateur peut conduire
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

  /// Les arrondis pour les mL des bières
  ButtonStyle beersMlShape() {
    return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    )));
  }

  /// Initialisation des sharedPreferences
  void getShared() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        userWeight = prefs.getInt('userWeight') ?? null;
        userGenderTx = (prefs.getInt('userGender') == 0) ? 0.7 : 0.6;
        isYoung = prefs.getBool('isYoung') ?? null;
        if (userWeight == null || isYoung == null) {
          Navigator.pushNamed(context, '/informations')
              .then((_) => getShared());
        }
        calculTaux();
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
