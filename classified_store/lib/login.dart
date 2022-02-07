// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sellerHome.dart';
import 'buyerHome.dart';

class Login extends StatefulWidget {
  final String? text;
  const Login({Key? key, @required this.text}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

enum userType { seller, buyer }

class _LoginState extends State<Login> {
  final String groupValue = "radioValue";
  String email = "";
  String password = "";
  userType? type = userType.seller;
  String utype = "";
  String alertTitle = "";
  String alertMsg = "";

  void checkLoginCredientials() {
    if (email.isEmpty) {
      alertTitle = "Alert";
      alertMsg = "Email cannot be Empty";
      showAlertDialog(context);
      return;
    } else if (password.isEmpty) {
      alertTitle = "Alert";
      alertMsg = "Password cannot be Empty";
      showAlertDialog(context);
      return;
    }
    if (type == userType.seller) {
      utype = "seller";
    } else {
      utype = "buyer";
    }
    checklogin();
  }

  void checklogin() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .where('userType', isEqualTo: utype)
        .get();

    if (docSnapshot.size > 0) {
      if (utype == "seller") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => sellerHome(text: email)));
      } else if (utype == "buyer") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => buyerHome(text: email)));
      } else {
        alertTitle = "Alert";
        alertMsg = "Something went wrong. Please try again.";
        showAlertDialog(context);
        return;
      }
    } else {
      alertTitle = "Not Allowed";
      alertMsg = "Invalid email or Password";
      showAlertDialog(context);
      return;
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("$alertTitle"),
      content: Text("$alertMsg"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
            title: Text("Classified Store"),
            backgroundColor: Color.fromARGB(255, 22, 121, 25),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Signup(
                              text: widget.text,
                            )))
              },
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
          ),
          body: Container(
            color: Colors.blueGrey[500],
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.height / 2.4,
                color: Colors.blueGrey[100],
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Column(children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Divider(
                                color: Colors.black,
                                height: 50,
                              )),
                        ),
                        const Text(
                          ' Login to Store ',
                          style: TextStyle(
                            fontSize: 27,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: const Divider(
                                color: Colors.black,
                                height: 50,
                              )),
                        ),
                      ]),
                    ]),
                    Center(
                      child:
                          const Text("Sell and Purchase by just few Clicks\n",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              )),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Container(
                          width: 300.0,
                          child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                                labelText: ' Email',
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter Email',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(17)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF546E7A),
                                        width: 1)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              style: TextStyle(fontSize: 16.0))),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                          width: 300.0,
                          child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                                labelText: ' Password',
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter Password',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(17)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF546E7A),
                                        width: 1)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              style: TextStyle(fontSize: 16.0))),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 50,
                        ),
                        const Text("Login As: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                        Radio<userType>(
                            value: userType.seller,
                            groupValue: type,
                            onChanged: (userType? value) {
                              setState(() {
                                type = value;
                              });
                            }),
                        const Text('Seller'),
                        Radio<userType>(
                            value: userType.buyer,
                            groupValue: type,
                            onChanged: (userType? value) {
                              setState(() {
                                type = value;
                              });
                            }),
                        const Text('Buyer'),
                      ],
                    ),
                    const SizedBox(height: 11),
                    Center(
                      child: TextButton(
                        child: const Text(
                          '   Login    ',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          checkLoginCredientials();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: const Text("if You don't have an Account:"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton(
                        child: const Text(
                          '  Create New Account  ',
                          style: TextStyle(fontSize: 23.0),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Signup(text: widget.text)));
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
