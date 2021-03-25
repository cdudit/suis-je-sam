import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suis_je_sam/tools/sharedTools.dart';

class Informations extends StatefulWidget {
  @override
  _InformationsState createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  double cardElevation = 10.0;
  int userWeight;
  int userHeight;
  int userGender;

  @override
  void initState() {
    super.initState();
    // Récupération des informations dans les shared préférences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        userWeight = prefs.getInt('userWeight') ?? null;
        userHeight = prefs.getInt('userHeight') ?? null;
        userGender = prefs.getInt('userGender') ?? null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vos informations"),
        actions: [
          TextButton(
            onPressed: () {
              if (userGender != null &&
                  userHeight != null &&
                  userWeight != null) {
                SharedTools()
                    .sendUserInformations(userWeight, userHeight, userGender);
                Navigator.pop(context);
              } else {
                /// Affichage d'une erreur si toutes les informations ne sont pas remplies
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            padding: EdgeInsets.only(right: 10.0),
                          ),
                          Text(
                            'Veuillez saisir toutes les informations',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          )
                        ])));
              }
            },
            child: Text("Sauvegarder", style: TextStyle(color: Colors.blue)),
          )
        ],
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
                          setState(() => userGender = 0);
                        }),
                      ),
                      InkWell(
                        child: cardPicture('images/woman.png', 3),
                        onTap: (() {
                          setState(() => userGender = 1);
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
                              value: (userWeight != null)
                                  ? userWeight.toDouble()
                                  : 0.0,
                              activeColor: Colors.green,
                              min: 0.0,
                              max: 150.0,
                              divisions: 150,
                              onChanged: ((double d) {
                                setState(() => userWeight = d.round());
                              })),
                          infosResult((userWeight != null)
                              ? userWeight.toString()
                              : '0')
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
                              value: (userHeight != null)
                                  ? userHeight.toDouble()
                                  : 140.0,
                              activeColor: Colors.green,
                              min: 140.0,
                              max: 210.0,
                              divisions: 70,
                              onChanged: ((double d) {
                                setState(() => userHeight = d.round());
                              })),
                          infosResult((userHeight != null)
                              ? userHeight.toString()
                              : '140'),
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
        width: MediaQuery.of(context).size.width / divider, fit: BoxFit.cover);
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
