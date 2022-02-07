// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'signup.dart';

class Select extends StatefulWidget {
  const Select({Key? key}) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String usert = "";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Classified Store"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 28.0,
                  ),
                )),
          ],
          backgroundColor: Color.fromARGB(255, 22, 121, 25),
        ),
        body: Container(
          color: Colors.greenAccent[400],
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Center(
                child: Image.asset(
                  "images/people.png",
                  height: 300,
                  width: 300,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: const Text(
                  "What do You Want?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 240, 23, 8),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: const Text(
                  "Select your purpose of using classified Store",
                  style: TextStyle(
                    color: Color.fromARGB(255, 240, 23, 8),
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Signup(
                                  text: 'buyer',
                                )));
                  },
                  child: const Text("Buy a Product"),
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
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Signup(
                                  text: 'seller',
                                )));
                  },
                  child: const Text("Sell a Product"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
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
      onWillPop: () async {
        return false;
      },
    );
  }
}
