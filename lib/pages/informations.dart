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
  int userGender;
  Size mqSize;

  @override
  void initState() {
    super.initState();
    // Récupération des informations dans les shared préférences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        userWeight = prefs.getInt('userWeight') ?? null;
        userGender = prefs.getInt('userGender') ?? null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mqSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Vos informations"),
        actions: [
          TextButton(
            onPressed: () {
              if (userGender != null && userWeight != null) {
                SharedTools()
                    .sendUserInformations(userWeight, userGender)
                    .then((value) => Navigator.pop(context));
              } else {
                // Affichage d'une erreur si toutes les informations ne sont pas remplies
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
                shape: cardRadius(),
                elevation: cardElevation,
                child: Container(
                  height: mqSize.height / 5,
                  padding: cardPadding(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: cardPicture('images/man.png', 3, 0),
                        onTap: (() {
                          setState(() => userGender = 0);
                        }),
                      ),
                      InkWell(
                        child: cardPicture('images/woman.png', 3, 1),
                        onTap: (() {
                          setState(() => userGender = 1);
                        }),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                shape: cardRadius(),
                elevation: cardElevation,
                child: Container(
                  height: mqSize.height / 5,
                  padding: cardPadding(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardPicture('images/weight.png', 4, false),
                      Container(
                        width: mqSize.width / 1.75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Slider(
                                value: (userWeight != null)
                                    ? userWeight.toDouble()
                                    : 1.0,
                                activeColor: Colors.green,
                                min: 1.0,
                                max: 150.0,
                                divisions: 150,
                                onChanged: ((double d) {
                                  setState(() => userWeight = d.round());
                                })),
                            infosResult((userWeight != null)
                                ? (userWeight.toString() + ' kg')
                                : '0 kg')
                          ],
                        ),
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

  /// Renvoie une card arrondie
  RoundedRectangleBorder cardRadius() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));
  }

  /// Affichage d'une image dans les bonnes dimensions pour l'écran
  Card cardPicture(String path, int divider, myUserGender) {
    return Card(
      elevation: (userGender == myUserGender) ? 20.0 : 0.0,
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Image.asset(path,
            width: MediaQuery.of(context).size.width / divider, fit: BoxFit.cover)
      )
    );
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
