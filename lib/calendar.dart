import 'package:flutter/material.dart';
import 'package:mobilappmercedes/event_editing.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'provider/event_provider.dart';

/*class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}
class CalendarState extends State<Calendar>

*/

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

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
