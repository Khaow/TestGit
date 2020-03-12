import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MyInfoPage extends StatefulWidget {
  final DocumentSnapshot ds;

  MyInfoPage({this.ds});

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String productImage;
  String id;
  String name;
  String address;
  String call;
  String price;
  String facility;
  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    productImage = widget.ds.data["image"];
    print(productImage);
    name = widget.ds.data["name"];
    address = widget.ds.data["address"];
    call = widget.ds.data["call"];
    price = widget.ds.data["price"];
    facility = widget.ds.data["facility"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'รายละเอียด',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 230.0,
                      width: 300.0,
                      child: productImage == ''
                          ? Text('Edit')
                          : Image.network(
                              productImage,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.call),
                      color: Colors.blue,
                      iconSize: 45,
                      onPressed: () => launch("tel://$call"),
                    ),
                    Text(
                      '$call',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                new ListTile(
                  leading: Icon(Icons.home, color: Colors.green),
                  title: new Text(
                    '$name',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.red),
                  title: new Text(
                    '$price',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: Icon(Icons.favorite, color: Colors.yellow),
                  title: new Text(
                    '$facility',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.brown,
                  ),
                  title: new Text(
                    '$address',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
