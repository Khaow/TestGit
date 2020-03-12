import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

File image;
String filename;

class CommonThings {
  static Size size;
}

class MyAddPage extends StatefulWidget {
  @override
  _MyAddPageState createState() => _MyAddPageState();
}

class _MyAddPageState extends State<MyAddPage> {
  TextEditingController priceInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;

  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String price;
  String address;
  String call;
  String facility;

  pickerCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  void createData() async {
    DateTime now = DateTime.now();
    String dindaengphoto = DateFormat('kk:mm:ss:MMMMd').format(now);
    var fullImageName = 'ProjectDindaeng-$dindaengphoto' + '.jpg';

    final StorageReference ref =
        FirebaseStorage.instance.ref().child(fullImageName);
    final StorageUploadTask task = ref.putFile(image);
    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();

    var fullPathImage = url;
    print(url);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('ProjectDindaeng').add({
        'ชื่อ': '$name',
        'เดือนละเกี่บาท': '$price',
        'เบอร์โทรศัพท์': '$call',
        'สิ่งอำนวยความสะดวก': '$facility',
        'ที่อยู่': '$address',
        'รูปภาพ': '$fullPathImage'
      });
      setState(() => id = ref.documentID);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มห้องพัก'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.blueAccent),
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null ? Text('เพิ่มรูปภาพห้องพัก') : Image.file(image),
                    ),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.camera_alt), onPressed: pickerCam),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),
                SizedBox(height: 6.0),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ชื่อ',
                      hintStyle: TextStyle(fontSize: 15),
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'โปรดใส่ชื่อห้องพัก';
                      }
                    },
                    onSaved: (value) => name = value,
                  ),
                ),
                SizedBox(height: 6.0),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ราคาเดือนละ',
                      hintStyle: TextStyle(fontSize: 15),
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'โปรดใส่ราคาห้องพักเดือน';
                      }
                    },
                    onSaved: (value) => price = value,
                  ),
                ),
                SizedBox(height: 6.0),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'สิ่งอำนวยความสะดวก',
                      hintStyle: TextStyle(fontSize: 15),
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'โปรดใส่สิ่งอำนวยความสะดวก';
                      }
                    },
                    onSaved: (value) => facility = value,
                  ),
                ),
                SizedBox(height: 6.0),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'เบอร์โทรศัพท์',
                      hintStyle: TextStyle(fontSize: 15),
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'โปรดใส่เบอร์โทรศัพท์';
                      }
                    },
                    onSaved: (value) => call = value,
                  ),
                ),
                SizedBox(height: 6.0),
                Container(
                  child: TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ที่อยู่',
                      hintStyle: TextStyle(fontSize: 15),
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'โปรดใส่ที่อยู่';
                      }
                    },
                    onSaved: (value) => address = value,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('ยืนยันข้อมูล',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                color: Colors.green,
              ),
            ],
          )
        ],
      ),
    );
  }
}
