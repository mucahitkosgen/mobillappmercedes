import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobilappmercedes/model/meeting.dart';
import 'package:mobilappmercedes/model/event_data_source.dart';
import 'package:mobilappmercedes/model/meeting_data_source.dart';
import '../../model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FireStoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await _db.collection("Events").get();
    final Random random = Random();
    final List<Color> _colorCollection = <Color>[];

    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));

    List<Meeting> list = snapShotsValue.docs
        .map((e) => Meeting(
            eventName: e.data()['title'],
            from: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['to']),
            to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['from']),
            background: _colorCollection[random.nextInt(9)],
            isAllDay: false))
        .toList();
  }

  Future<void> saveEvent(Event event) async {
    _db
        .collection('users')
        .doc('posts')
        .collection(event.eventId)
        .add(event.createMap());
    return _db.collection('Events').doc(event.eventId).set(event.createMap());
  }

  Stream<List<Event>> getEvents() {
    return _db.collection('Events').snapshots().map((snapshot) => snapshot.docs
        .map((document) => Event.fromFirestore(document.data()))
        .toList());
  }

  Future<void> removeEvent(String eventId) {
    return _db.collection('Products').doc(eventId).delete();
  }
}












/*class DatabaseService {
  Future<void> dbcreateEvent(String title) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }
}*/
