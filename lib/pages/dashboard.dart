import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double taux = 0.0;
  int drinked = 0;

  @override
  Widget build(BuildContext context) {
    Size mqSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord"),
        actions: [
          IconButton(
              onPressed: (() => refresh()),
              icon: Icon(Icons.refresh, color: Colors.white),
              iconSize: 30),
          IconButton(
              onPressed: (() => Navigator.pushNamed(context, '/informations')),
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
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
                  borderRadius: BorderRadius.circular(20.0)
                ),
                elevation: 10.0,
                child: InkWell(
                    onTap: (() => incrementTaux()),
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0),
                      width: mqSize.width / 2,
                      child: Column(
                        children: [
                          Container(
                              height: mqSize.height / 6,
                              width: mqSize.width / 3,
                              child: Image.asset('images/beer.png')),
                          Align(
                            alignment: Alignment(0.8, -1.0),
                            heightFactor: 0.5,
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              onPressed: null,
                              child: Text(drinked.toString(),
                                  style: TextStyle(fontSize: 30, color: Colors.grey[800])),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              Card(
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

  void incrementTaux() {
    setState(() {
      taux += 0.2;
      drinked++;
    });
  }

  void refresh() {
    setState(() {
      taux = 0.0;
      drinked = 0;
    });
  }
}
