import 'package:flutter/material.dart';
import 'package:mobilappmercedes/event_editing.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Calendar"),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        todayHighlightColor: Colors.white,
        todayTextStyle: const TextStyle(color: Colors.black),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
        blackoutDatesTextStyle: const TextStyle(
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Event_Editing()),
          );
        },
      ),
    );
  }
}
