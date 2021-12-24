import '../../model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveEvent(Event event) async {
    if (event.limitedParticipation == false) {
      return _db.collection('Events').doc(event.eventId).set(event.createMap());
    } else {
      return _db
          .collection('LimitedParticiption')
          .doc(event.eventId)
          .set(event.createMap());
    }
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
