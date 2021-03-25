import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Size mqSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord"),
        actions: [
          IconButton(
              onPressed: null,
              icon: Icon(Icons.refresh, color: Colors.white), iconSize: 30
          ),
          IconButton(
              onPressed: (() => Navigator.pushNamed(context, '/informations')),
              icon: Icon(Icons.account_circle, color: Colors.white,), iconSize: 30
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
                elevation: 10.0,
                child: InkWell(
                  onTap: (() {
                    print('ok');
                  }),
                  child: Container(
                    height: mqSize.height / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Ajouter un verre', style: TextStyle(
                            fontSize: 40
                        )),
                        Image.asset('images/beer.png',
                            width: mqSize.width / 6)
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 10.0,
                child: Container(
                  height: mqSize.height / 3,
                  width: mqSize.width,
                  child: Center(
                    child: Text("0g/L", style: TextStyle(
                        fontSize: 80
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
