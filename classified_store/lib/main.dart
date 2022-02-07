// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'select.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCj6smTe0Dw3X__az3P-oa8igNVBz0TQlY",
      appId: "1:567303645019:android:14640265871a66052f5c7e",
      messagingSenderId: "567303645019",
      projectId: "classifiedstore-432f7",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'classified Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        elevation: 0,
        title: Image.asset(
          'images/home.png',
          height: 40,
          width: 40,
        ),
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
                'images/store.png',
                height: 350,
                width: 350,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: const Text(
                "WELCOME TO",
                style: TextStyle(
                  color: Color.fromARGB(255, 240, 23, 8),
                  fontFamily: 'Open Sans',
                  fontSize: 20,
                ),
              ),
            ),
            Center(
              child: const Text(
                "Classified Store",
                style: TextStyle(
                    color: Color.fromARGB(255, 240, 23, 8),
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: const Text(
                "Your Own Store",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Center(
              child: const Text(
                "Buy & Sell for free anywhere in Pakistan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
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
                      MaterialPageRoute(builder: (context) => Select()),
                    );
                  },
                  child: const Text("GET STARTED"),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 22, 121, 25),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }
}
