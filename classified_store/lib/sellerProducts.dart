// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerProducts extends StatefulWidget {
  final String? text;
  const SellerProducts({Key? key, @required this.text}) : super(key: key);

  @override
  _SellerProductsState createState() => _SellerProductsState();
}

var allRecordsList = [];
bool isLoading = true;
String? sellerEmail = "";

class _SellerProductsState extends State<SellerProducts> {
  @override
  void initState() {
    super.initState();

    getAlldata().then((value) {
      setLoading();
    });
  }

  void setLoading() {
    sellerEmail = "";
    sellerEmail = widget.text;
    setState(() {
      isLoading = false;
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
              title: Text("Store's Products"),
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
              color: Color.fromARGB(255, 206, 201, 201),
              child: Center(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        child: (allRecordsList.length == 0)
                            ? Container(
                                child: const Center(
                                  child: Text(
                                    "No Products Available",
                                    style: TextStyle(
                                        fontSize: 26,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: allRecordsList.length,
                                itemBuilder: (BuildContext context, int index) {
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
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                            color: Colors.red,
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                trailing: allRecordsList[index]
                                                        .isFav
                                                    ? IconButton(
                                                        icon: Icon(
                                                            Icons.favorite,
                                                            color: Colors.red),
                                                        onPressed: () => {
                                                          setState(() {
                                                            allRecordsList[
                                                                    index]
                                                                .isFav = false;
                                                          }),
                                                        },
                                                      )
                                                    : IconButton(
                                                        icon: Icon(
                                                            Icons
                                                                .favorite_outline,
                                                            color: Colors.red),
                                                        onPressed: () => {
                                                          print(
                                                              "Index is $index"),

                                                          setState(() {
                                                            allRecordsList[
                                                                    index]
                                                                .isFav = true;
                                                          }),
                                                          // changeFav(),
                                                        },
                                                      ),
                                              ),
                                              Image.network(
                                                allRecordsList[index].photourl,
                                                height: 200,
                                                width: 200,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(16.0),
                                                alignment: Alignment.bottomLeft,
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      "Description: ${allRecordsList[index].description}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      "Condition: ${allRecordsList[index].condition}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              ButtonBar(
                                                children: [
                                                  TextButton(
                                                    child: const Text(
                                                      'DELETE',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {/* ... */},
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                        'LEARN MORE'),
                                                    onPressed: () {
                                                      var productID =
                                                          allRecordsList[index]
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
                                }),
                      ),
              ),
            ),
          )),
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
}

Future<List> getAlldata() async {
  allRecordsList = [];
  var collection = FirebaseFirestore.instance.collection('products');
  var docSnapshot =
      await collection.where('email', isEqualTo: sellerEmail).get();

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
        }
      }
    });
    allRecordsList.add(obj);
  });
  // print(allRecordsList[0].photourl);

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
                // allRecordsList = [],
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
