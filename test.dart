import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: Column(
        children: <Widget>[
          _button('dance'),
          _button('comic-kuan'),
          _button('cats'),
        ],
      ),
    );
  }

  Widget _button(event) => FlatButton(
        child: Text(event),
        onPressed: () async {
          DocumentReference docRef =
              Firestore.instance.collection('laptops').document('asus');
          DocumentSnapshot doc = await docRef.get();
          List tags = doc.data['tags'];
          if (tags.contains(event) == true) {
            docRef.updateData({
              'tags': FieldValue.arrayRemove([event])
            });
          } else {
            docRef.updateData(
              {
                'tags': FieldValue.arrayUnion([event])
              },
            );
          }
        },
      );
}
