import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobilappmercedes/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'model/event.dart';
import 'utils.dart';

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
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  bool isChecked = false;
  final numberOfPeopleController = TextEditingController();

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
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const CloseButton(),
        actions: buildEditingActions(),
        title: const Text("Create Event"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              const SizedBox(height: 30),
              buildDateTimePickers(),
              const SizedBox(height: 30),
              buildDescription(),
              const SizedBox(height: 30),
              buildLP(),
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
          onPressed: saveForm,
          icon: const Icon(Icons.done),
          label: const Text("Save"),
        )
      ];

  Widget buildTitle() => TextFormField(
        style: const TextStyle(fontSize: 24, color: Colors.black),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Add Title'),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
        // onChanged: (title) => eventProvider.changeTitle(title),
      );

  Widget buildDescription() => TextFormField(
        style: const TextStyle(fontSize: 15, color: Colors.black),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Add Description'),
        onFieldSubmitted: (_) => saveForm(),
        validator: (description) => description != null && description.isEmpty
            ? 'Description cannot be empty'
            : null,
        controller: descriptionController,
        //onChanged: (description) => EventProvider().changeTitle(description),
      );

  Widget buildLP() => Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Limited Participation',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          Expanded(
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                  // EventProvider().changeLimitedParticipation(isChecked);
                });

                if (isChecked) {
                  _displayTextInputDialog(context);
                }
              },
            ),
          ),
        ],
      ); //'What is the maximum number of participants?'

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('What is the maximum number of participants?'),
            content: TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              onFieldSubmitted: (_) => saveForm(),
              validator: (nop) => nop != null && nop.isEmpty
                  ? 'Number of People cannot be empty'
                  : null,
              controller: numberOfPeopleController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), hintText: 'Give Number'),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    isChecked = false;
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    onFieldSubmitted:
                    (_) => saveForm();
                    validator:
                    (numberOfPeople) =>
                        numberOfPeople != null && numberOfPeople.isEmpty
                            ? 'numberOfPeople cannot be empty'
                            : null;
                    controller:
                    numberOfPeopleController;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: 'FROM',
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropdownField(
                  text: Utils.toDate(fromDate),
                  onClicked: () => pickFromDateTime(pickDate: true),
                )),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    //EventProvider().changeFrom(date);
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    // EventProvider().changeTo(date);
    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2020, 1),
        lastDate: DateTime(2100),
      );

      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

// *******************************************************************************************************************
  Widget buildTo() => buildHeader(
        header: 'To',
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropdownField(
                  text: Utils.toDate(toDate),
                  onClicked: () => pickToDateTime(pickDate: true),
                )),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );
  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );

  Future saveForm() async {
    if (_formKey.currentState!.validate()) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      int val = int.parse(numberOfPeopleController.text.trim());
      eventProvider.changeTitle(titleController.text);
      eventProvider.changeDescription(descriptionController.text);
      eventProvider.changeFrom(fromDate);
      eventProvider.changeTo(toDate);
      eventProvider.changeLimitedParticipation(isChecked);
      eventProvider
          //.changeNumberOfPeople(int.parse(numberOfPeopleController.text));
          .changeNumberOfPeople(val);

      eventProvider.saveData();
      Navigator.of(context).pop();

      final event = Event(
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: toDate,
        limitedParticipation: isChecked,

        numberOfPeople: int.parse(numberOfPeopleController.text.trim()),

        //numberOfPeople: 20, //int.parse(numberOfPeopleController.text),
        eventId: '',
      );
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}

/*final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: toDate,

        /*
        *
        *
        *
        *
        *
        Butun kullanicidan alinacak bilgileri burada form olarak kaydediyor.*defult degerleri degistir 
        
        */
        limitedParticipation: isChecked,
        numberOfPeople: int.parse(numberOfPeopleController.text),
      );
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);
      DatabaseService.dbcreateEvent(provider);
      // yukarıda onChange methodu içine yazdıklarını buraya yazz
      Navigator.of(context).pop();
    }
    if (isChecked == true) {
      FirebaseStorage.instance.collection("limitedparticiption").add({});
    } else {}*/ 