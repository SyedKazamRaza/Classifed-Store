// ignore_for_file: prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({Key? key}) : super(key: key);

  @override
  _MarketplaceState createState() => _MarketplaceState();
}

var allRecordsList = [];
var totalProducts = [];
bool isLoading = true;

class _MarketplaceState extends State<Marketplace> {
  @override
  void initState() {
    super.initState();

    getAlldata().then((value) {
      setLoading();
    });
  }

  void setLoading() {
    setState(() {
      isLoading = false;
    });
  }

  String dropdownvalue = 'All products';
  var items = [
    'All products',
    'Furniture',
    'Electronic product',
    'Vehicle',
    'Property',
    'Kitchen Good',
    'Clothes',
    'Other'
  ];

  _textMe(sellerphone) async {
    // Android
    var ph = sellerphone;
    String result = ph.substring(1, 11);

    var uri =
        'sms:+92$result?body=hello%20there!%20I%20saw%20your%20product%20on%20classified%20Store%20App%20I%20am%20interested%20in%20buying%20it';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms::+92 305 284 1214?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  void searchByCategory(category) {
    if (category == "All products") {
      setState(() {
        allRecordsList = totalProducts;
      });
      return;
    }
    var listme =
        totalProducts.where((prod) => prod.pcategory == category).toList();
    setState(() {
      allRecordsList = listme;
    });
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
                title: const Text("All Available Products"),
                backgroundColor: Color.fromARGB(255, 22, 121, 25),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () =>
                      {allRecordsList = [], Navigator.of(context).pop()},
                ),
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.production_quantity_limits_rounded,
                          size: 28.0,
                        ),
                      )),
                ],
              ),
              body: Container(
                  child: Center(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        child: ListView(
                          children: [
                            Container(
                              color: Color.fromARGB(255, 206, 201, 201),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "Filter Products: ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        color:
                                            Color.fromARGB(255, 161, 149, 149),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            DropdownButton(
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                              value: dropdownvalue,
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                              ),
                                              items: items.map((String items) {
                                                return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(
                                                      "  " + items,
                                                      // style: TextStyle(color: Colors.blue),
                                                    ));
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalue = newValue!;
                                                });
                                                searchByCategory(dropdownvalue);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: (allRecordsList.length == 0)
                                  ? Column(children: const [
                                      SizedBox(
                                        height: 170,
                                      ),
                                      Center(
                                        child: Text(
                                          "No Products Found",
                                          style: TextStyle(
                                              fontSize: 26,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ])
                                  : Container(
                                      color: Color.fromARGB(255, 206, 201, 201),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemCount: allRecordsList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (allRecordsList.isNotEmpty) {
                                              return Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Card(
                                                      elevation: 4.0,
                                                      child: Column(
                                                        children: [
                                                          ListTile(
                                                            title: Text(
                                                              "${allRecordsList[index].pname}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22),
                                                            ),
                                                            subtitle: Container(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      "${allRecordsList[index].pcategory}"),
                                                                  Text(
                                                                    "  Price: Rs ${allRecordsList[index].price}/-",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            18),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            trailing:
                                                                allRecordsList[
                                                                            index]
                                                                        .isFav
                                                                    ? IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .favorite,
                                                                            color:
                                                                                Colors.red),
                                                                        onPressed:
                                                                            () =>
                                                                                {
                                                                          setState(
                                                                              () {
                                                                            allRecordsList[index].isFav =
                                                                                false;
                                                                          }),
                                                                        },
                                                                      )
                                                                    : IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .favorite_outline,
                                                                            color:
                                                                                Colors.red),
                                                                        onPressed:
                                                                            () =>
                                                                                {
                                                                          setState(
                                                                              () {
                                                                            allRecordsList[index].isFav =
                                                                                true;
                                                                          }),
                                                                          // changeFav(),
                                                                        },
                                                                      ),
                                                          ),
                                                          // Container(
                                                          //   height: 100.0,
                                                          // child:
                                                          Image.network(
                                                            allRecordsList[
                                                                    index]
                                                                .photourl,
                                                            height: 200,
                                                            width: 200,
                                                          ),

                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Description: ${allRecordsList[index].description}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                Text(
                                                                  "Seller Name: ${allRecordsList[index].sellerName}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          ButtonBar(
                                                            children: [
                                                              TextButton(
                                                                child: const Text(
                                                                    'CONTACT SELLER'),
                                                                onPressed: () {
                                                                  var sellerPh =
                                                                      allRecordsList[
                                                                              index]
                                                                          .sellerPhone;
                                                                  _textMe(
                                                                      sellerPh);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text(
                                                                    'LEARN MORE'),
                                                                onPressed: () {
                                                                  var productID =
                                                                      allRecordsList[
                                                                              index]
                                                                          .id;
                                                                  serachSingleProduct(
                                                                      productID);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SingleProduct()));
                                                                },
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              );
                                            }
                                            return Container(
                                              child: const Center(
                                                child: Text(
                                                  "No Products Available.",
                                                  style: TextStyle(
                                                      fontSize: 26,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                            )
                          ],
                        ),
                      ),
              )))),
      onWillPop: () async {
        return false;
      },
    );
  }
}

class Product {
  String pname = "";
  String pcategory = "";
  String condition = "";
  String photourl = "";
  String description = "";
  String sellerName = "";
  String date = "";
  String price = "";
  String id = "";
  bool isFav = false;
  String vehicleType = "";
  String model = "";
  String location = "";
  String area = "";
  String elecType = "";
  String sellerPhone = "";
}

Future<List> getAlldata() async {
  allRecordsList = [];
  var collection = FirebaseFirestore.instance.collection('products');
  var docSnapshot = await collection.get();

  docSnapshot.docs.forEach((element) {
    var obj = new Product();
    element.data().forEach((key, value) {
      {
        if (key == "pid") {
          obj.id = value;
        } else if (key == "productName") {
          obj.pname = value;
        } else if (key == "sellerName") {
          obj.sellerName = value;
        } else if (key == "price") {
          obj.price = value;
        } else if (key == "photourl") {
          obj.photourl = value;
        } else if (key == "description") {
          obj.description = value;
        } else if (key == "date") {
          obj.date = value;
        } else if (key == "category") {
          obj.pcategory = value;
        } else if (key == "condition") {
          obj.condition = value;
        } else if (key == "Type") {
          obj.vehicleType = value;
        } else if (key == "model") {
          obj.model = value;
        } else if (key == "location") {
          obj.location = value;
        } else if (key == "area") {
          obj.area = value;
        } else if (key == "Type") {
          obj.elecType = value;
        } else if (key == "sellerPhone") {
          obj.sellerPhone = value;
        }
      }
    });

    allRecordsList.add(obj);
  });
  totalProducts = allRecordsList;
  return allRecordsList;
}

var product;
void serachSingleProduct(value) {
  product = allRecordsList.firstWhere((prod) => prod.id == value);
}

class SingleProduct extends StatefulWidget {
  const SingleProduct({Key? key}) : super(key: key);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool isFav = (product.isFav ? true : false);

  _textMe(sellerphone) async {
    // Android
    var ph = sellerphone;
    String result = ph.substring(1, 11);

    var uri =
        'sms:+92$result?body=hello%20there!%20I%20saw%20your%20product%20on%20classified%20Store%20App%20I%20am%20interested%20in%20buying%20it';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms::+92 305 284 1214?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: MaterialApp(
        title: 'classified Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.brown),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "${product.pname}",
              style: const TextStyle(
                  fontSize: 26,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromARGB(255, 209, 204, 204),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => {
                product = {},
                Navigator.of(context).pop()
              },
            ),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFav = !isFav;
                      });
                    },
                    child: isFav
                        ? const Icon(
                            Icons.favorite,
                            size: 34.0,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            size: 34.0,
                            color: Colors.red,
                          ),
                  )),
            ],
          ),
          body: Container(
            color: Color.fromARGB(255, 209, 204, 204),
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Image.network(
                  product.photourl,
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 55,
                    ),
                    Text(
                      "Posted on ${product.date}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.brown,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  elevation: 10,
                  child: ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.green,
                    ),
                    title: Text(
                      "${product.description}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.brown,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  elevation: 10,
                  child: ListTile(
                    leading: const Icon(
                      Icons.category_rounded,
                      color: Colors.green,
                    ),
                    title: Text(
                      "Category: ${product.pcategory}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.brown,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  elevation: 10,
                  child: ListTile(
                    leading: const Icon(
                      Icons.microwave_outlined,
                      color: Colors.green,
                    ),
                    title: Text(
                      "Condition:  ${product.condition}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (product.pcategory == "Vehicle")
                  Container(
                    child: Column(
                      children: <Widget>[
                        Card(
                          color: Colors.brown,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10,
                          child: ListTile(
                            leading: const Icon(
                              Icons.directions_bus_outlined,
                              color: Colors.green,
                            ),
                            title: Text(
                              "Model:  ${product.model}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              Icons.done,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Colors.brown,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10,
                          child: ListTile(
                            leading: const Icon(
                              Icons.donut_small_outlined,
                              color: Colors.green,
                            ),
                            title: Text(
                              "Vehicle Type:  ${product.vehicleType}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              Icons.done,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (product.pcategory == "Electronic product")
                  Container(
                    child: Column(
                      children: <Widget>[
                        Card(
                          color: Colors.brown,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10,
                          child: ListTile(
                            leading: const Icon(
                              Icons.tv_sharp,
                              color: Colors.green,
                            ),
                            title: Text(
                              "Type:  ${product.elecType}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              Icons.done,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (product.pcategory == "Property")
                  Container(
                    child: Column(
                      children: <Widget>[
                        Card(
                          color: Colors.brown,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10,
                          child: ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.green,
                            ),
                            title: Text(
                              "Location:  ${product.location}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              Icons.done,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Colors.brown,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10,
                          child: ListTile(
                            leading: const Icon(
                              Icons.bungalow_outlined,
                              color: Colors.green,
                            ),
                            title: Text(
                              "Total Area:  ${product.area} marlas",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              Icons.done,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                Card(
                  color: Colors.brown,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  elevation: 10,
                  child: ListTile(
                    leading: const Icon(
                      Icons.hail,
                      color: Colors.green,
                    ),
                    title: Text(
                      "Seller Name: ${product.sellerName}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.brown,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  elevation: 10,
                  child: ListTile(
                    leading: const Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.green,
                    ),
                    title: Text(
                      "Price: Rs. ${product.price}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      var sellerPh = product.sellerPhone;
                      _textMe(sellerPh);
                    },
                    child: const Text(
                      "Contact Seller",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 14, 146, 2),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ),
                const SizedBox(
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
