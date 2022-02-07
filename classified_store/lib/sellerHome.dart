// ignore_for_file: camel_case_types, prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'addproduct.dart';
import 'sellerProducts.dart';
import 'main.dart';

class sellerHome extends StatefulWidget {
  final String? text;
  const sellerHome({Key? key, @required this.text}) : super(key: key);

  @override
  _sellerHomeState createState() => _sellerHomeState();
}

class _sellerHomeState extends State<sellerHome> {
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
            title: Text("${widget.text}'s Store"),
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
                  height: 60,
                ),
                Center(
                  child: Image.asset(
                    "images/new seller.png",
                    height: 250,
                    width: 250,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddProduct(text: widget.text)));
                    },
                    child: const Text("Add New Product"),
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
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SellerProducts(text: widget.text)));
                    },
                    child: const Text("Show My Products"),
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
                const SizedBox(
                  height: 20,
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
