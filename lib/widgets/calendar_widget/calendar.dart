import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:mobilappmercedes/aboutpage/about_page.dart';
import 'package:mobilappmercedes/event_editing.dart';
import 'package:mobilappmercedes/model/event_data_source.dart';
import 'package:mobilappmercedes/model/meeting.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'package:mobilappmercedes/widgets/calendar_widget/task_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:mobilappmercedes/model/meeting_data_source.dart';

import '../../provider/event_provider.dart';

/*class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}
class CalendarState extends State<Calendar>

*/
final service = FireStoreService();
FirebaseFirestore _db = FirebaseFirestore.instance;
MeetingDataSource? meet;
List<Color> _colorCollection = <Color>[];

final List<String> options = <String>['Add', 'Delete', 'Update'];
final databaseReference = FirebaseFirestore.instance;

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    final provider = Provider.of<EventProvider>(context, listen: false);
    getDataFromFireStore();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text(
            "Calendar",
          ),
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AboutPage();
                  }));
                },
                child: Icon(Icons.info_outline_rounded),
              ),
            )
          ]),
      body: SfCalendar(
        view: CalendarView.week,
        monthViewSettings: MonthViewSettings(showAgenda: true),
        //dataSource: EventDaTaSource(events),
        todayHighlightColor: Colors.white,
        todayTextStyle: const TextStyle(color: Colors.black),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
        dataSource: meet,
        appointmentTimeTextFormat: 'HH:mm',

        blackoutDatesTextStyle: const TextStyle(
          backgroundColor: Colors.white,
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Event_Editing()),
          );
        },
      ),*/
    );
  }
}

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
          from: e.data()['from'].toDate(),
          //from: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['to']),
          to: e.data()['to'].toDate(),
          background: _colorCollection[random.nextInt(9)],
          isAllDay: false))
      .toList();

  meet = MeetingDataSource(list);
}

_AppointmentDataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(minutes: 10)),
    subject: 'Meeting',
    color: Colors.blue,
  ));

  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
