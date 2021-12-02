import 'package:flutter/material.dart';
import 'package:mobilappmercedes/event_editing.dart';
import 'package:mobilappmercedes/task_widget.dart';
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
        title: const Text(
          "Calendar",
        ),
        backgroundColor: Colors.black,
      ),
      body: SfCalendar(
        view: CalendarView.month,
        //dataSource: EventDaTaSource(events),
        todayHighlightColor: Colors.white,
        todayTextStyle: const TextStyle(color: Colors.black),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
        onLongPress: (details) {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.setDate(details.date!);
          showModalBottomSheet(
            context: context,
            builder: (context) => TasksWidget(),
          );
        },
        blackoutDatesTextStyle: const TextStyle(
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Event_Editing()),
          );
        },
      ),
    );
  }
}
