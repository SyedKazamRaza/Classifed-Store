// ignore_for_file: file_names, prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'marketplace.dart';
import 'main.dart';

class buyerHome extends StatefulWidget {
  final String? text;
  const buyerHome({Key? key, @required this.text}) : super(key: key);

  @override
  _buyerHomeState createState() => _buyerHomeState();
}

class _buyerHomeState extends State<buyerHome> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: MaterialApp(
        title: 'classified Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Buyer Panel"),
            backgroundColor: Color.fromARGB(255, 22, 121, 25),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.face,
                      size: 28.0,
                    ),
                  )),
            ],
          ),
          body: Container(
            color: Colors.greenAccent[400],
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 45,
                ),
                Center(
                  child: Image.asset(
                    "images/sale.png",
                    height: 350,
                    width: 350,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Marketplace()));
                    },
                    child: const Text("Go to Marketplace"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        textStyle: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: const Text("Sign Out"),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 233, 84, 74),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        textStyle: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
