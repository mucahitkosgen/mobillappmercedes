import 'package:flutter/material.dart';
import 'package:mobilappmercedes/event_editing.dart';
import 'package:mobilappmercedes/model/event_data_source.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'package:mobilappmercedes/widgets/calendar_widget/task_widget.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../provider/event_provider.dart';

/*class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}
class CalendarState extends State<Calendar>

*/
final service = FireStoreService();

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    final provider = Provider.of<EventProvider>(context, listen: false);
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
        //dataSource: event.creservice.getEvents(). //_getCalendarDataSource(),
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
