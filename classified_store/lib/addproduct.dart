// ignore_for_file: constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, unnecessary_new, avoid_unnecessary_containers, avoid_print, library_prefixes, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';

class AddProduct extends StatefulWidget {
  final String? text;
  const AddProduct({Key? key, @required this.text}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

enum productCondition { New, used }

class _AddProductState extends State<AddProduct> {
  String productName = "";
  String productPrice = "";
  String description = "";
  String model = "";
  String location = "";
  String totalArea = "";
  productCondition? condition = productCondition.used;
  String conditionStr = "";

  String dropdownvalue = 'Furniture';
  var items = [
    'Furniture',
    'Electronic product',
    'Vehicle',
    'Property',
    'Kitchen Good',
    'Clothes',
    'Other'
  ];

  String propertyTypevalue = "House";
  var propertyTypes = ["House", "Plot", "Bangla", "Land for sale", "Other"];

  String electronicsTypevalue = "Television";
  var electronicsType = [
    "Television",
    "Laptop/Computer",
    "Refrigerator",
    "Oven",
    "Mobile",
    "Other"
  ];

  String vehicleTypevalue = "MotorBike";
  var vehicleType = ["MotorBike", "Car", "Bicycle", "Bus", "Van", "Others"];

  final imagePicker = ImagePicker();
  File imageFile = new File("");
  bool imgSet = false;
  File cameraFile = new File("");
  bool camImgSet = false;

  File _image = new File("");
  File _prevImage = new File("");
  String _uploadedFileURL = "";

  // String msg = "";

  Future getImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      _image = File(image.path);
      setState(() {
        imgSet = true;
        camImgSet = false;
      });
    }
  }

  Future getImageFromCam() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      cameraFile = File(image.path);
      _image = File(image.path);
      setState(() {
        camImgSet = true;
        imgSet = false;
      });
    }
  }

  String alertTitle = "";
  String alertMsg = "";

  Future uploadFile() async {
    if (_prevImage == _image) {
      alertTitle = "Alert";
      alertMsg = "Photo already uploaded.";
      showAlertDialog(context);
      return;
    }
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child('photos/${Path.basename(_image.path)}}');
    UploadTask uploadTask = ref.putFile(_image);

    uploadTask.then((res) {
      res.ref.getDownloadURL().then((fileURL) {
        _uploadedFileURL = fileURL;
        print("*************Photo Uploaded to Firebase Storage*********");
        print(_uploadedFileURL);
        _prevImage = _image;
        insertdataUsingAdd(_uploadedFileURL);
        alertTitle = "Succcess";
        alertMsg = "Product successfully Added.";
        showAlertDialog(context);
      });
    });
  }

  void validateData() {
    getUsername();
    if (imgSet == false && camImgSet == false) {
      alertTitle = "Alert";
      alertMsg = "Product image is required.";
      showAlertDialog(context);
      return;
    }
    if (productName.isEmpty) {
      alertTitle = "Alert";
      alertMsg = "Product Name is required.";
      showAlertDialog(context);
      return;
    } else if (productPrice.isEmpty) {
      alertTitle = "Alert";
      alertMsg = "Product price is required.";
      showAlertDialog(context);
      return;
    } else if (description.isEmpty) {
      alertTitle = "Alert";
      alertMsg = "Product description cannot be Empty";
      showAlertDialog(context);
      return;
    }

    if (dropdownvalue == "Vehicle") {
      if (model.isEmpty) {
        alertTitle = "Alert";
        alertMsg = "Vehicle Model is required.";
        showAlertDialog(context);
        return;
      }
    } else if (dropdownvalue == "Property") {
      if (location.isEmpty || totalArea.isEmpty) {
        alertTitle = "Alert";
        if (location.isEmpty) {
          alertMsg = "Property location is required.";
        } else {
          alertMsg = "Property total area is required.";
        }
        showAlertDialog(context);
        return;
      }
    }
    if (condition == productCondition.New) {
      conditionStr = "New";
    } else {
      conditionStr = "Used";
    }
    uploadFile();
  }

  String username = "";
  String phoneNo = "";
  void getUsername() async {
    String? email = widget.text;
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.where('email', isEqualTo: email).get();

    docSnapshot.docs.forEach((element) {
      element.data().forEach((key, value) {
        if (key == "username") {
          username = value;
        }
        if (key == "phoneNumber") {
          phoneNo = value;
        }
      });
    });
  }

  void insertdataUsingAdd(String url) async {
    final DateTime now = DateTime.now();
    var dateForPK = now.toString();
    final DateFormat formatter = DateFormat('EE dd-MM-yyyy');
    final String formatted = formatter.format(now);
    String? email = widget.text;
    print("seller email is $email");
    var objToStore = {
      "pid": dateForPK,
      "email": email,
      "sellerName": username,
      "productName": productName,
      "sellerPhone": phoneNo,
      "price": productPrice,
      "description": description,
      "category": dropdownvalue,
      "photourl": url,
      "date": formatted,
    };
    if (dropdownvalue != "Property") {
      objToStore["condition"] = conditionStr;
    }
    if (dropdownvalue == "Vehicle") {
      objToStore["model"] = model;
      objToStore["Type"] = vehicleTypevalue;
    } else if (dropdownvalue == "Electronic product") {
      objToStore["Type"] = electronicsTypevalue;
    } else if (dropdownvalue == "Property") {
      objToStore["Type"] = propertyTypevalue;
      objToStore["location"] = location;
      objToStore["area"] = totalArea;
    }

    await FirebaseFirestore.instance
        .collection("products")
        .add(objToStore)
        .then((value) {
      print("Successfully record added");
    }).catchError((error) {
      print("Error during new record add. $error");
    });
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
          primarySwatch: Colors.brown,
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 155, 152, 152),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Container(
            color: Color.fromARGB(255, 155, 152, 152),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text("Add New Product",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 10,
                ),
                (() {
                  if (camImgSet == true) {
                    return Container(
                      child: Image.file(
                        cameraFile,
                        height: 150,
                        width: 100,
                      ),
                    );
                  } else if (imgSet == true) {
                    return Container(
                      child: Image.file(
                        imageFile,
                        height: 150,
                        width: 100,
                      ),
                    );
                  }
                  return Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.black, // border color
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5), // border width
                      child: Container(
                        // or ClipRRect if you need to clip the content
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(
                              255, 88, 86, 86), // inner circle color
                        ),
                        child: Center(
                          child: const Text(
                            'Product\n Image\n  here',
                            style: TextStyle(fontSize: 20),
                          ),
                        ), // inner content
                      ),
                    ),
                  );
                }()),
                const SizedBox(height: 15),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      getImage();
                    },
                    child: const Text("Pick photo from Gallery"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      getImageFromCam();
                    },
                    child: const Text("Pick photo from Camera"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                      width: 327.0,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.data_saver_on_outlined),
                          border: OutlineInputBorder(),
                          labelText: ' Product Name',
                          filled: true,
                          fillColor: Color.fromARGB(255, 211, 204, 204),
                          hintText: 'Product Name',
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(17)),
                              borderSide: BorderSide(
                                  color: const Color(0xFF546E7A), width: 1)),
                        ),
                        style: TextStyle(fontSize: 16.0),
                        onChanged: (value) {
                          setState(() {
                            productName = value;
                          });
                        },
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: const [
                    SizedBox(
                      width: 47,
                    ),
                    Text(
                      "Select Product Category:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 105,
                    ),
                    Container(
                      color: Color.fromARGB(255, 104, 102, 102),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton(
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            value: dropdownvalue,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                  value: items, child: Text("  " + items));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    SizedBox(
                      width: 47,
                    ),
                    Text(
                      "Enter Details here:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                      width: 327.0,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.price_change_outlined),
                          border: OutlineInputBorder(),
                          labelText: ' Product Price',
                          filled: true,
                          fillColor: Color.fromARGB(255, 211, 204, 204),
                          hintText: ' Price (in PKR)',
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(17)),
                              borderSide: BorderSide(
                                  color: const Color(0xFF546E7A), width: 1)),
                        ),
                        style: TextStyle(fontSize: 16.0),
                        onChanged: (value) {
                          setState(() {
                            productPrice = value;
                          });
                        },
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                (() {
                  if (dropdownvalue != "Property") {
                    return Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 47,
                          ),
                          const Text(" Condition: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              )),
                          Radio<productCondition>(
                              value: productCondition.used,
                              groupValue: condition,
                              onChanged: (productCondition? value) {
                                setState(() {
                                  condition = value;
                                });
                              }),
                          const Text(
                            'Used',
                            style: TextStyle(fontSize: 17),
                          ),
                          Radio<productCondition>(
                              value: productCondition.New,
                              groupValue: condition,
                              onChanged: (productCondition? value) {
                                setState(() {
                                  condition = value;
                                });
                              }),
                          const Text(
                            'New',
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container();
                }()),
                (() {
                  if (dropdownvalue == "Property") {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 80,
                              ),
                              const Text(
                                "Type: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                color: Color.fromARGB(255, 104, 102, 102),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropdownButton(
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                      value: propertyTypevalue,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                      items: propertyTypes.map((String items) {
                                        return DropdownMenuItem(
                                            value: items,
                                            child: Text("  " + items));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          propertyTypevalue = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                                width: 327.0,
                                child: TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.location_on,
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: ' Location',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 211, 204, 204),
                                    hintText: ' Location',
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
                                      location = value;
                                    });
                                  },
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                                width: 327.0,
                                child: TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.house),
                                    border: OutlineInputBorder(),
                                    labelText: ' Total Area',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 211, 204, 204),
                                    hintText: ' Total Area in Marlas',
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
                                      totalArea = value;
                                    });
                                  },
                                )),
                          ),
                        ],
                      ),
                    );
                  } else if (dropdownvalue == "Vehicle") {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 60,
                              ),
                              const Text(
                                "Type: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                color: Color.fromARGB(255, 104, 102, 102),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropdownButton(
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                      value: vehicleTypevalue,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                      items: vehicleType.map((String items) {
                                        return DropdownMenuItem(
                                            value: items,
                                            child: Text("  " + items));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          vehicleTypevalue = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                                width: 327.0,
                                child: TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.car_rental_rounded),
                                    border: OutlineInputBorder(),
                                    labelText: ' Model',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 211, 204, 204),
                                    hintText: ' Vehicle Model',
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
                                      model = value;
                                    });
                                  },
                                )),
                          ),
                        ],
                      ),
                    );
                  } else if (dropdownvalue == "Electronic product") {
                    return Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 60,
                          ),
                          const Text(
                            "Type: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            color: Color.fromARGB(255, 104, 102, 102),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButton(
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  value: electronicsTypevalue,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                  ),
                                  items: electronicsType.map((String items) {
                                    return DropdownMenuItem(
                                        value: items,
                                        child: Text("  " + items));
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      electronicsTypevalue = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                }()),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                      width: 327.0,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.event_note),
                          border: OutlineInputBorder(),
                          labelText: ' Description',
                          filled: true,
                          fillColor: Color.fromARGB(255, 211, 204, 204),
                          hintText: ' Product details',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 40, horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(17)),
                              borderSide: BorderSide(
                                  color: const Color(0xFF546E7A), width: 1)),
                        ),
                        style: TextStyle(fontSize: 16.0),
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print("hello");
                      validateData();
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => AddProduct()));
                    },
                    child: const Text("Add Product"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 10,
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
