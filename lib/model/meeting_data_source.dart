import 'package:flutter/cupertino.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'meeting.dart';

class MeetingDataSource extends CalendarDataSource {
  final service = FireStoreService();

  MeetingDataSource(List<Meeting> appointments) {
    this.appointments = appointments;
  }

  Meeting getEvent(int index) => appointments![index] as Meeting;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).eventName;

  @override
  Color getColor(int index) => getEvent(index).background;
}
