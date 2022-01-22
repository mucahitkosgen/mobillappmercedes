import 'package:flutter/cupertino.dart';
import 'package:mobilappmercedes/model/event.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'package:uuid/uuid.dart';

class EventProvider with ChangeNotifier {
  final service = FireStoreService();
  var uuid = Uuid();

  final List<Event> _events = [];
  late final String _eventId;
  late final String _title;
  late final String _description;
  late final DateTime _from;
  late final DateTime _to;
  late final String _user;
  late final String _image;
  late final DateTime _date;
  late final String _userimage;
  //late final Color _backgroundColor;

  late final bool _limitedParticipation;
  late final int _numberOfPeople;
  late final int _participants;
//getters:
  List<Event> get events => _events;
  String get getTitle => _title;
  String get getuserimage => _userimage;
  String get getDescription => _description;
  DateTime get getFrom => _from;
  DateTime get getTo => _to;
  //Color get getBackgroundColor => _backgroundColor;
  bool get getLimitedParticipation => _limitedParticipation;
  int get getNumberOfPeople => _numberOfPeople;
  int get getParticipants => _participants;
  String get getuser => _user;
  String get getImage => _image;
  DateTime get getDate => _date;

  DateTime _selectedDate = DateTime.now();

  DateTime get selecteDate => _selectedDate;
  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => _events;

//Setter
  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

// **************************
  void changeTitle(String val) {
    _title = val;
    notifyListeners();
  }

  void changedate(DateTime val) {
    _date = val;
    notifyListeners();
  }

  void changeDescription(String val) {
    _description = val;
    notifyListeners();
  }

  void changeFrom(DateTime val) {
    _from = val;
    notifyListeners();
  }

  void changeTo(DateTime val) {
    _to = val;
    notifyListeners();
  }

  void changeuserimage(String val) {
    _userimage = val;
    notifyListeners();
  }

  void changeuser(String val) {
    _user = val;
    notifyListeners();
  }

  void changeimage(String val) {
    _image = val;
    notifyListeners();
  }
  /*void changeBackgroundColor(Color val) {
    _backgroundColor = val;
    notifyListeners();
  }*/

  void changeLimitedParticipation(bool val) {
    _limitedParticipation = val;
    notifyListeners();
  }

  void changeNumberOfPeople(int val) {
    _numberOfPeople = val;
    notifyListeners();
  }

  void changeParticipants(int val) {
    _participants = val;
    notifyListeners();
  }

  void saveData() {
    var newEvent = Event(
        title: getTitle,
        eventId: uuid.v4(),
        description: getDescription,
        from: getFrom,
        limitedParticipation: getLimitedParticipation,
        numberOfPeople: getNumberOfPeople,
        participants: getParticipants,
        user: getuser,
        userimage: getuserimage,
        image: getImage,
        date: getDate,
        to: getTo);
    service.saveEvent(newEvent);
  }
}
