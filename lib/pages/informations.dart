import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suis_je_sam/tools/sharedTools.dart';

class Informations extends StatefulWidget {
  @override
  _InformationsState createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  double cardElevation = 5.0;
  int userWeight;
  int userGender;
  Size mqSize;
  bool isYoung;

  @override
  void initState() {
    super.initState();
    // Récupération des informations dans les shared préférences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        userWeight = prefs.getInt('userWeight') ?? 1;
        userGender = prefs.getInt('userGender') ?? 1;
        isYoung = prefs.getBool('isYoung') ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mqSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Vos informations")
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
                child: MergeSemantics(
                  child: ListTile(
                    title: Text('Jeune conducteur',
                        style: TextStyle(fontSize: 25.0)),
                    trailing: CupertinoSwitch(
                      value: isYoung,
                      onChanged: (bool value) {
                        setState(() {
                          isYoung = value;
                          sendToShared();
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        isYoung = !isYoung;
                        sendToShared();
                      });
                    },
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
                      InkWell(
                        child: cardPicture('images/man.png', 3, 0),
                        onTap: (() {
                          setState(() {
                            userGender = 0;
                            sendToShared();
                          });
                        }),
                      ),
                      InkWell(
                        child: cardPicture('images/woman.png', 3, 1),
                        onTap: (() {
                          setState(() {
                            userGender = 1;
                            sendToShared();
                          });
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
                                  setState(() {
                                    userWeight = d.round();
                                    sendToShared();
                                  });
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

  void sendToShared() {
    SharedTools().sendUserInformations(userWeight, userGender, isYoung);
  }

  /// Renvoie une card arrondie
  RoundedRectangleBorder cardRadius() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));
  }

  /// Affichage d'une image dans les bonnes dimensions pour l'écran
  Card cardPicture(String path, int divider, myUserGender) {
    return Card(
      elevation: (userGender == myUserGender) ? cardElevation : 0.0,
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
