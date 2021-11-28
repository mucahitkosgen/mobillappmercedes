import 'package:flutter/material.dart';

class Event_Editing extends StatefulWidget {
  final Event_Editing? event;
  const Event_Editing({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  Event_EditingState createState() => Event_EditingState();
}

class Event_EditingState extends State<Event_Editing> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 4));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildEditingActions(),
        title: const Text("Create a Event"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              const SizedBox(height: 12),
              // buildDateTimePickers(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {},
          icon: const Icon(Icons.done),
          label: const Text("Save"),
        )
      ];

  Widget buildTitle() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Add Title'),
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
      );

  /*Widget buildDateTimePickers() => Column(
        children: [
          buildFrom();
        ],
      );*/

  /* Widget buildFrom()=>Row(children: [
    Expanded(child: buildDropdownField(
      text:Utils.toDate(fromDate),
    ))
  ],)*/
}
