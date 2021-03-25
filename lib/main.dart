import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: 'Vos informations'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double cardElevation = 10.0;
  double userWeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  height: 125,
                ),
              ),
              Card(
                elevation: cardElevation,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Poids", style: TextStyle(
                        fontSize: 40.0
                      )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Slider(
                              value: userWeight,
                              activeColor: Colors.green,
                              min: 0.0,
                              max: 150.0,
                              divisions: 150,
                              onChanged: ((double d) {
                                setState(() {
                                  userWeight = d;
                                });
                              })),
                          Text(userWeight.round().toString(), style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w200
                          ))
                        ],
                      ),
                    ],
                  ),
                  height: 125,
                ),
              ),
              Card(
                elevation: cardElevation,
                child: Container(
                  height: 125,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: null,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 40.0,
        ),
      ),
    );
  }
}
