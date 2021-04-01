import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suis_je_sam/tools/sharedTools.dart';
import 'package:suis_je_sam/tools/globals.dart' as globals;

class Informations extends StatefulWidget {
  @override
  _InformationsState createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  // Informations utilisateur
  int userWeight;
  int userGender;
  bool isYoung;

  // Variables pour le design
  double clayRadius = globals.clayRadius;
  Color baseColor;
  Size mqSize;

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
    baseColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title:
              Text("Vos informations", style: TextStyle(color: Colors.white))),
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
                    title: Text('Jeune conducteur',
                        style: TextStyle(fontSize: 25.0)),
                    trailing: ClayContainer(
                      color: baseColor,
                      borderRadius: 50,
                      curveType: CurveType.convex,
                      child: CupertinoSwitch(
                        activeColor: Colors.lightBlue,
                        value: isYoung ?? false,
                        onChanged: (bool value) {
                          setState(() {
                            isYoung = value;
                            sendToShared();
                          });
                        },
                      ),
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
              ClayContainer(
                color: baseColor,
                borderRadius: clayRadius,
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
              ClayContainer(
                color: baseColor,
                borderRadius: clayRadius,
                child: Container(
                  height: mqSize.height / 5,
                  padding: cardPadding(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("images/weight.png", width: mqSize.width / 4),
                      Container(
                        width: mqSize.width / 1.75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: ClayContainer(
                                color: baseColor,
                                borderRadius: clayRadius,
                                child: CupertinoSlider(
                                    value: (userWeight != null)
                                        ? userWeight.toDouble()
                                        : 1.0,
                                    activeColor: Colors.lightBlue,
                                    min: 1.0,
                                    max: 150.0,
                                    divisions: 150,
                                    onChanged: ((double d) {
                                      setState(() {
                                        userWeight = d.round();
                                        sendToShared();
                                      });
                                    })),
                              ),
                            ),
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
  ClayContainer cardPicture(String path, int divider, myUserGender) {
    return ClayContainer(
        color: baseColor,
        borderRadius: 75,
        width: mqSize.width / divider,
        height: mqSize.height / divider,
        emboss: (userGender == myUserGender),
        curveType:
            (userGender == myUserGender) ? CurveType.concave : CurveType.convex,
        depth: (userGender == myUserGender) ? 15 : 0,
        spread: (userGender == myUserGender) ? 10 : 0,
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: (userGender == myUserGender) ? Icon(Icons.check, size: 50) : Text(""),
          decoration: BoxDecoration(
              color: (userGender == myUserGender) ? Colors.green : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(75)),
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity((userGender == myUserGender) ? 0.5 : 1), BlendMode.dstATop),
                  image: Image.asset(path).image,
                  fit: BoxFit.cover)),
        ));
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
