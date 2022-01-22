import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilappmercedes/config/styles.dart';
import 'package:mobilappmercedes/provider/event_provider.dart';
import 'package:mobilappmercedes/screens/feed_screen.dart';
import 'package:mobilappmercedes/screens/main_screen.dart';
import 'package:mobilappmercedes/screens/profile_screen2.dart';
import 'package:provider/provider.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'aboutpage/about_page.dart';
import 'model/event.dart';
import 'utils.dart';
import 'components/rounded_button.dart';
import "package:image/image.dart" as Im;

import 'package:cloud_firestore/cloud_firestore.dart';

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
  int index = 0;
  final List _screens = [
    Event_Editing(),
    FeedScreen(),
    ProfileScreen2(),
    AboutPage(),
  ];
  int _currentIndex = 0;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  late String fileContentBase64;
  String? image;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String user;
  late String userimage;
  late DocumentSnapshot snapshot;
  bool isChecked = false;
  final numberOfPeopleController = TextEditingController();
  final pictureController = TextEditingController();

  FirebaseFirestore _db = FirebaseFirestore.instance;

  late File file;

  @override
  void initState() {
    super.initState();

    fileContentBase64 =
        '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';
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 4));
    }
    //user = "kullanici";
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    /*var currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    print('-------' + currentUser!.uid);
    if (currentUser != null) {
      db.collection('users').doc(currentUser.uid).snapshots().map((snapshot) {
        String user = snapshot.data()!["KullaniciAdi"];
        print('*****' + user);
      });
    }*/
    var currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    print('-------' + currentUser!.uid);
    // if (currentUser != null) {
    var userEmail = currentUser.email;
    print('-------' + userEmail!);

    db.collection("users").doc(userEmail).get().then((value) {
      userimage = value.data()!["Photo"];
    });

    FirebaseFirestore.instance
        .collection('users')
        .where('Email', arrayContainsAny: [userEmail])
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            String user = doc["KullaniciAdi"];
          });
        });

    user = userEmail;
    print('*****' + user);
    //  }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            leading: const CloseButton(),
            actions: buildEditingActions(),
            title: const Text("Mercedes Media",
                style: TextStyle(color: Colors.blue))),
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
                const SizedBox(height: 30),
                buildSelectImage(),
                const SizedBox(height: 30),

                /*Column(
                children: [
                  SizedBox(
                    width: 15,
                    height: 20,
                    child: (RoundedButton(
                      text: "Select Image",
                      color: Colors.blue,
                      textColor: Colors.black,
                      press: selectImage(context),
                    )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(file),
                      ),
                    ),
                  ),
                ],
              ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomBarWidget() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: _screens[_currentIndex],
          )
        ]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          elevation: 0.0,
          items: [
            Icons.home,
            Icons.supervisor_account_rounded,
            Icons.add_box,
            Icons.info
          ]
              .asMap()
              .map((key, value) => MapEntry(
                    key,
                    BottomNavigationBarItem(
                      title: Text(''),
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: _currentIndex == key
                              ? Colors.blue[600]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Icon(value),
                      ),
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
    );
  }

  Widget buildSelectImage() => FlatButton.icon(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 30.0,
        ),
        onPressed: () {
          selectImage(context);
        },
        color: Colors.blue[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          'Select Image',
          style: Styles.buttonTextStyle,
        ),
        textColor: Colors.white,
      );

/*  RoundedButton(
        text: "Select Image",
        color: Colors.blue,
        textColor: Colors.black,
        press: ,
      );*/
  handleTakePhoto() async {
    Navigator.pop(context);
    File file = (await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    )) as File;
    image = handleUploadImage(file);
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    setState(() {
      if (image != null) {
        file = File(image.path);
        File imageFile = File(file.path);
        var fileContent = imageFile.readAsBytesSync();
        fileContentBase64 = base64.encode(fileContent);
      } else {
        print("No image selected");
        fileContentBase64 =
            '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';
      }
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18.0))),
            // title: Text('Select Choose', style: TextStyle(color: Colors.blue)),
            children: <Widget>[
              /* SimpleDialogOption(
                child: Text('Photo with Camera',
                    style: TextStyle(color: Colors.grey[900])),
                onPressed: handleTakePhoto,
              ),*/
              SimpleDialogOption(
                child: Text('Image from Gallery',
                    style: TextStyle(color: Colors.grey[900])),
                onPressed: handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: Text('Cancel', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  buildUploadedForm() {
    return Text("File Uploaded");
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
        style: const TextStyle(fontSize: 18, color: Colors.white),
        decoration: const InputDecoration(
          labelText: "Add Title",
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
        // onChanged: (title) => eventProvider.changeTitle(title),
      );

  Widget buildDescription() => TextFormField(
        style: const TextStyle(fontSize: 15, color: Colors.white),
        decoration: const InputDecoration(
          labelText: "Add Description",
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (description) => description != null && description.isEmpty
            ? 'Description cannot be empty'
            : null,
        controller: descriptionController,
        //onChanged: (description) => EventProvider().changeTitle(description),
      );

  Widget buildLP() => Row(
        children: [
          // const Expanded(
          //   flex: 2,
          //   child: Text(
          //     '',
          //     style: TextStyle(fontSize: 17.0, color: Colors.white),
          //   ),
          // ),
          Expanded(
            child: CheckboxListTile(
              checkColor: Colors.white,
              activeColor: Colors.purple,
              title: Text("Limited Participation",
                  style: TextStyle(color: Colors.white)),
              tileColor: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0))),
              selectedTileColor: Colors.white,
              secondary: Icon(
                Icons.access_alarms_outlined,
                color: Colors.white,
              ),
              value: isChecked,
              controlAffinity: ListTileControlAffinity.platform,
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
            elevation: 22.0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18.0))),
            title: const Text(
              'What is the maximum number of participants?',
              style: TextStyle(color: Colors.black),
            ),
            content: TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15, color: Colors.blue),
              onFieldSubmitted: (_) => saveForm(),
              validator: (nop) => nop != null && nop.isEmpty
                  ? 'Number of People cannot be empty'
                  : null,
              controller: numberOfPeopleController,
              decoration: const InputDecoration(
                labelText: "Give me a Number",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            actions: <Widget>[
              RoundedButton(
                color: Colors.red,
                textColor: Colors.white,
                text: 'No',
                press: () {
                  setState(() {
                    isChecked = false;
                    Navigator.pop(context);
                  });
                },
              ),
              RoundedButton(
                color: Colors.green,
                textColor: Colors.white,
                text: 'Yes',
                press: () {
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
    //setState(() => fromDate = date);
    setState(() {
      if (toDate.day == date.day && toDate.hour > date.hour) {
        fromDate = DateTime(
                date.year, date.month, date.day, toDate.hour, toDate.minute)
            .add(Duration(hours: 2));
        //fromDate = date.add(Duration(hours: 3));
      } else {
        fromDate = date;
      }
    });
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
    setState(() => toDate = date); //fromDate.add(Duration(hours: 3));
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      //gun
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2020, 1),
        lastDate: DateTime(2100),
      );

      if (date == null) return null;
      if (date.isBefore(initialDate)) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      //saat
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

// ***************************************
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
        title: Text(text, style: TextStyle(color: Colors.white)),
        trailing: const Icon(
          Icons.navigate_next_rounded,
          color: Colors.white,
        ),
        focusColor: Colors.blue,
        tileColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
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
  handleUploadImage(imageFile) async {
    //final bytes = await Io.File(imageFile).readAsBytes();
// or    String image = base64.encode(bytes);
    var fileContent = imageFile.readAsBytesSync();
    var image = base64.encode(fileContent);

    return image;
  }

  Future saveForm() async {
    if (_formKey.currentState!.validate()) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      int val = int.parse(numberOfPeopleController.text.trim());
      eventProvider.changeTitle(titleController.text);
      eventProvider.changeDescription(descriptionController.text);
      eventProvider.changeFrom(fromDate);
      eventProvider.changeTo(toDate);
      eventProvider.changeLimitedParticipation(isChecked);
      eventProvider.changeuser(user);
      eventProvider.changeuserimage(userimage);
      eventProvider.changeimage(fileContentBase64);
      eventProvider.changedate(DateTime.now());
      eventProvider
          //.changeNumberOfPeople(int.parse(numberOfPeopleController.text));
          .changeNumberOfPeople(val);

      eventProvider.saveData();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));

      final event = Event(
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: toDate,
        limitedParticipation: isChecked,
        image: fileContentBase64,
        user: user,
        userimage: userimage,
        date: DateTime.now(),
        numberOfPeople: int.parse(numberOfPeopleController.text.trim()),

        //numberOfPeople: 20, //int.parse(numberOfPeopleController.text),
        eventId: '',
      );

      // eventProvider.deleteEvent(event);
    }
  }

  getuser() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    String a = 'dfdfd';

    if (currentUser != null) {
      var userEmail = currentUser.email;
    }

    /*FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: [userEmail]).snapshots();

      String rsm = snapshot.get(['Photo']);
      print('------------' + rsm);*/

    /* db.collection("users").doc(userEmail).get().then((value){
      print(value.data());
    });*/
    /* String user = db
          .collection('users')
          .where('email', arrayContainsAny: [userEmail])
          .snapshots()
          .toString();
      print('*****' + user);
    }*/

    /*List<Map<String,dynamic>>=_db.collection('users').where('email', arrayContainsAny: [userEmail]).snapshots().map((snapshot) => snapshot.docs
        .map((document) =>document.data(
         
        )*/

    /* db.collection('users').doc(currentUser.uid).snapshots().map((snapshot) {
      String user = snapshot.data()!["KullaniciAdi"];
      print('*****' + user);
    });
    }*/
    return a;
    // here you write the codes to input the data into firestore
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
    return Colors.blue;
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