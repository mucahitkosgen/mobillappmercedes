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
  //late final Color _backgroundColor;

  late final bool _limitedParticipation;
  late final int _numberOfPeople;
//getters:
  List<Event> get events => _events;
  String get getTitle => _title;
  String get getDescription => _description;
  DateTime get getFrom => _from;
  DateTime get getTo => _to;
  //Color get getBackgroundColor => _backgroundColor;
  bool get getLimitedParticipation => _limitedParticipation;
  int get getNumberOfPeople => _numberOfPeople;

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

  void saveData() {
    var newEvent = Event(
        title: getTitle,
        eventId: uuid.v4(),
        description: getDescription,
        from: getFrom,
        limitedParticipation: getLimitedParticipation,
        numberOfPeople: getNumberOfPeople,
        to: getTo);
    service.saveEvent(newEvent);
  }
}
