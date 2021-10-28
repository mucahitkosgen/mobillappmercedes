import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreIslemleri extends StatefulWidget {
  @override
  _FirestoreIslemleriState createState() => _FirestoreIslemleriState();
}

class _FirestoreIslemleriState extends State<FirestoreIslemleri> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Islemleri"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Veri Ekle"),
              color: Colors.green,
              onPressed: _veriEkle,
            )
          ],
        ),
      ),
    );
  }

  void _veriEkle() {
    Map<String, dynamic> nurdanEkle = Map();
    nurdanEkle['email'] = "e170503034@stud.tau.edu.tr";
    nurdanEkle['password'] = "nurdans";

    _firestore
        .collection("users")
        .doc("nurdanseker1")
        .set(nurdanEkle)
        .then((v) => debugPrint("nurdan eklendi"));
  }
}
