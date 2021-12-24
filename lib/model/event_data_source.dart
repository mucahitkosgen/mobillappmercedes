import 'package:flutter/cupertino.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event.dart';

class EventDataSource extends CalendarDataSource {
  final service = FireStoreService();

  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }
  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  //Color getColor(int index) => getEvent(index).backgroundColor;

  bool limitedParticipation(int index) => getEvent(index).limitedParticipation;

  int numberOfPeople(int index) => getEvent(index).numberOfPeople;
  String getDescription(int index) => getEvent(index).description;
}
