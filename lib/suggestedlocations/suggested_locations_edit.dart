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
import 'package:mobilappmercedes/dashboard/screens/bottom_nav_screen.dart';
import 'package:mobilappmercedes/provider/event_provider.dart';
import 'package:mobilappmercedes/seconhandsale/secondhandsalescreen.dart';
import 'package:mobilappmercedes/suggestedlocations/suggested_locations.dart';
import 'package:mobilappmercedes/suggestedlocations/suggested_locations_main.dart';
import 'package:mobilappmercedes/suggestedlocations/suggested_locations_post.dart';
import 'package:provider/provider.dart';
import 'package:mobilappmercedes/seconhandsale/salepost.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'package:mobilappmercedes/model/event.dart';
import 'package:mobilappmercedes/utils.dart';
import 'package:mobilappmercedes/components/rounded_button.dart';
import "package:image/image.dart" as Im;
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestedLocationsEdit extends StatefulWidget {
  final SuggestedLocationsEdit? salePost;
  const SuggestedLocationsEdit({
    Key? key,
    this.salePost,
  }) : super(key: key);

  @override
  SuggestedLocationsEditState createState() => SuggestedLocationsEditState();
}

class SuggestedLocationsEditState extends State<SuggestedLocationsEdit> {
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
  final priceController = TextEditingController();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  var uuid = Uuid();
  late File file;

  @override
  void initState() {
    super.initState();

    fileContentBase64 =
        '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';
    if (widget.salePost == null) {
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
        print('*************' + user);
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
    print('*************' + user);
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
                const SizedBox(height: 60),
                buildTitle(),
                const SizedBox(height: 30),
                // buildDateTimePickers(),
                const SizedBox(height: 30),
                //konum
                buildDescription(),
                const SizedBox(height: 30),
                // buildLP(),
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
        file = File(image!.path);
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
              /*SimpleDialogOption(
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
          labelText: "Your Suggestion ...",
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
          labelText: "Location",
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
            ? 'Location cannot be empty'
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
      // int val = int.parse(numberOfPeopleController.text.trim());

      Navigator.of(context).pop();

      LocationsPost locationpost = LocationsPost(
        title: titleController.text,
        description: descriptionController.text,

        image: fileContentBase64,
        user: user,
        userimage: userimage,
        date: DateTime.now(),
        likes: 0,
        //price: priceController.text,

        //numberOfPeople: 20, //int.parse(numberOfPeopleController.text),
        eventId: uuid.v4(),
      );
      _db
          .collection('SuggestedLocationsPost')
          .doc(locationpost.eventId)
          .set(locationpost.createMap());
      try {
        _db
            .collection('users')
            .doc(locationpost.user)
            .collection('posts')
            .doc(locationpost.eventId)
            .set(locationpost.createMap());
      } catch (e) {
        debugPrint(e.toString());
      }
      //service.saveEvent(newEvent);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SuggestedLocationsMain()));
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
      print('*************' + user);
    }*/

    /*List<Map<String,dynamic>>=_db.collection('users').where('email', arrayContainsAny: [userEmail]).snapshots().map((snapshot) => snapshot.docs
        .map((document) =>document.data(
         
        )*/

    /* db.collection('users').doc(currentUser.uid).snapshots().map((snapshot) {
      String user = snapshot.data()!["KullaniciAdi"];
      print('*************' + user);
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