import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:suis_je_sam/model/helper.dart';
import 'package:suis_je_sam/tools/globals.dart' as globals;

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  List<Helper> helps = [];
  double beerDegree = globals.beerDegree;
  double wineDegree = globals.wineDegree;
  int wineMl = globals.wineMl;
  Size mqSize;
  double clayRadius = 20.0;
  Color baseColor;

  @override
  void initState() {
    super.initState();
    helps = [
      new Helper(
          imgPath: "images/beer.png",
          content:
              'Une bière de ${(beerDegree * 100).round()}°, vous choisissez la quantité.'),
      new Helper(
          imgPath: "images/wine.png",
          content:
              'Un verre de vin de ${(wineMl / 10).round()}cL à ${(wineDegree * 100).round()}°.'),
      new Helper(
          imgPath: "images/eating.png",
          content:
              'A jeun, la redescente se fait au bout de 30min, contre 60 sinon.'),
      new Helper(
          imgPath: "images/warning.png",
          content:
              'Le taux n\'est qu\'indicatif et ne remplace pas un alcootest.'),
      new Helper(
          imgPath: "images/information.png",
          content:
              'Toutes vos informations sont sauvegardées sur votre appareil, par conséquent ne sont ni revendues, ni partagées.'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    mqSize = MediaQuery.of(context).size;
    baseColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Aide", style: TextStyle(color: Colors.white))),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: helpList(),
        ),
      ),
    );
  }

  /// Retourne la liste de widgets à mettre dans le centre d'aide
  List<Widget> helpList() {
    List<Widget> rows = [];
    helps.forEach((element) {
      rows.add(Container(
          padding: EdgeInsets.only(bottom: 10.0),
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: ClayContainer(
            color: baseColor,
            borderRadius: clayRadius,
            child: Container(
                margin: EdgeInsets.all(5.0),
                child: ListTile(
                  title: Text(element.content, style: TextStyle(fontSize: 18)),
                  leading:
                      Image.asset(element.imgPath, width: mqSize.width / 10),
                )),
          )));
    });
    return rows;
  }
}
