// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sellerHome.dart';
import 'buyerHome.dart';
import 'select.dart';

class Signup extends StatefulWidget {
  final String? text;
  const Signup({Key? key, @required this.text}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final String groupValue = "radioValue";
  bool isCheck = false;
  String username = "";
  String address = "";
  String phoneNo = "";
  String password = "";
  String email = "";
  String alertMsg = "";
  String alertTitle = "";
  bool moveToNext = false;
  bool isExist = false;

  void insertdataUsingAdd() async {
    isExist = false;
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.where('email', isEqualTo: email).get();
    if (docSnapshot.size > 0) {
      isExist = true;
    }

    if (isExist) {
      alertTitle = "Email already registered.";
      alertMsg = "Just login to your account or change the Email.";
      showAlertDialog(context);
      return;
    }
    await FirebaseFirestore.instance.collection("users").add({
      "username": username,
      "email": email,
      "password": password,
      "phoneNumber": phoneNo,
      "userType": widget.text,
      "address": address,
    }).then((value) {
      alertTitle = "Confirmation";
      alertMsg = "User successfully register to Store";
      moveToNext = true;
      showAlertDialog(context);
    }).catchError((error) {
      alertTitle = "Action Failded";
      alertMsg = "Failed to register new User.";
      showAlertDialog(context);
    });
  }

  void checkDataValidity() {
    final bool isValid = EmailValidator.validate(email);
    if (username.length < 6) {
      alertTitle = "Invalid Username";
      alertMsg = "Username must be Greater than 5 characters";
      showAlertDialog(context);
      return;
    } else if (password.length < 6) {
      alertTitle = "Invalid Password";
      alertMsg = "Password must be Greater than 5 characters";
      showAlertDialog(context);
      return;
    } else if (!isValid) {
      alertTitle = "Invalid Email";
      alertMsg = "Email format Not correct.";
      showAlertDialog(context);
      return;
    } else if (address.length < 6) {
      alertTitle = "Invalid Address";
      alertMsg = "Address must be Greater than 5 characters";
      showAlertDialog(context);
      return;
    } else if (phoneNo.length != 11) {
      alertTitle = "Invalid Phone No";
      alertMsg = "Please enter 11 digit phone number";
      showAlertDialog(context);
      return;
    }
    moveToNext = false;
    insertdataUsingAdd();
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        if (moveToNext == true) {
          if (widget.text == "seller") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => sellerHome(text: email)));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => buyerHome(text: email)));
          }
        }
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
        title: 'classified store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Classifies Store"),
            backgroundColor: Color.fromARGB(255, 22, 121, 25),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Select())),
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
                height: MediaQuery.of(context).size.height / 1.25,
                width: MediaQuery.of(context).size.height / 2.4,
                color: Colors.blueGrey[100],
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        (() {
                          if (widget.text == "buyer") {
                            return "Create a Buyer Account";
                          }
                          if (widget.text == "seller") {
                            return "Create a Seller Account";
                          }
                          return "Create Account";
                        }()),
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                      const Text(
                        ' Register ',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                    ]),
                    Center(
                      child: const Text(
                          "Create Your free account, it just takes a minute\n",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    const SizedBox(height: 7),
                    Center(
                      child: Container(
                          width: 260.0,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                              labelText: ' Email',
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Enter email',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(17)),
                                  borderSide: BorderSide(
                                      color: const Color(0xFF546E7A),
                                      width: 1)),
                            ),
                            style: TextStyle(fontSize: 16.0),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          )),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Container(
                          width: 260.0,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_circle),
                              border: OutlineInputBorder(),
                              labelText: ' User Name',
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Enter Username',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(17)),
                                  borderSide: BorderSide(
                                      color: const Color(0xFF546E7A),
                                      width: 1)),
                            ),
                            style: TextStyle(fontSize: 16.0),
                            onChanged: (value) {
                              setState(() {
                                username = value;
                              });
                            },
                          )),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                          width: 260.0,
                          child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.home),
                                border: OutlineInputBorder(),
                                labelText: ' Address',
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter Address',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(17)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF546E7A),
                                        width: 1)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  address = value;
                                });
                              },
                              style: TextStyle(fontSize: 16.0))),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                          width: 260.0,
                          child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.local_phone),
                                border: OutlineInputBorder(),
                                labelText: ' Phone Number',
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter Phone Number',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(17)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF546E7A),
                                        width: 1)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  phoneNo = value;
                                });
                              },
                              style: TextStyle(fontSize: 16.0))),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                          width: 260.0,
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
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          value: isCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheck = value!;
                            });
                          },
                        ),
                        const Text("I accept all the terms & conditions."),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Center(
                      child: TextButton(
                        child: const Text(
                          '   Register   ',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (isCheck == true) {
                            checkDataValidity();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: const Text(
                        'If you already have an Account',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton(
                        child: const Text(
                          '   Sign In     ',
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
                          setState(() {
                            email = "";
                            username = "";
                            address = "";
                            phoneNo = "";
                            password = "";
                            isCheck = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login(text: widget.text)),
                          );
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
