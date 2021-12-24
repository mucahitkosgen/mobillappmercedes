/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilappmercedes/widgets/calendar_widget/calendar.dart';
import 'package:mobilappmercedes/event_editing.dart';
import 'package:mobilappmercedes/provider/event_provider.dart';
import 'package:provider/provider.dart';

import 'model/event.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildViewingAction(context, event),
        ),
        body: ListView(
          padding:const EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
          const SizedBox(height: 32),
            Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        if (!event.isAllDay) buildDate('To', event.to),
      ],
    );
  }

 Widget buildDate(String title,DateTime date){
    event.title=title,


  }

  List<Widget> buildViewingAction(BuildContext context, Event event) => [
        /*IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder:(context)=>Event_Editing(event:event),
            
            ),
          ),
        ),*/
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context);
            provider.deleteEvent(event);
            Navigator.of(context).pop();
            MaterialPageRoute(builder: (context) => Calendar());
          },
        ),
      ];
}
*/