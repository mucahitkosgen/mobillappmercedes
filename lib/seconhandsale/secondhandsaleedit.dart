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
import 'package:provider/provider.dart';
import 'package:mobilappmercedes/seconhandsale/salepost.dart';
import 'package:mobilappmercedes/services/firestore_services.dart';
import 'package:mobilappmercedes/model/event.dart';
import 'package:mobilappmercedes/utils.dart';
import 'package:mobilappmercedes/components/rounded_button.dart';
import "package:image/image.dart" as Im;
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SecondHandSaleEdit extends StatefulWidget {
  final SecondHandSaleEdit? salePost;
  const SecondHandSaleEdit({
    Key? key,
    this.salePost,
  }) : super(key: key);

  @override
  SecondHandSaleEditState createState() => SecondHandSaleEditState();
}

class SecondHandSaleEditState extends State<SecondHandSaleEdit> {
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
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASQAAACsCAMAAADlsyHfAAAA9lBMVEUrtlYnMzMMp1AAi1b///8tuVr6/vwnJDAnt1UAo0Wz38OY1K8pr1MoLTIdakAAp0gSsknO7deJ0p0ftE8pf0YnLzInKTEAg0fn8OsYf0UApULX7+F3zY9pwoteq4hYwnbx+vQdKysAjFPp9esoVTsiSTtJv20piUkumm0WZkZEn3ZGUFDx8vIAiU+Vx7Gx1cUaXEIoTTkPllYWnVYJoE4oXD0pekUnQTYqnU8nODQrv1kLklYNeU8RcUvC5ss/vGWV1qcArjwnHy8nFy4oYz5MqnYqk0wqn1AeUT4IglJrr48gb0FCYVY0hWUzn20PQTF+uZ47smoRR6IPAAAIYElEQVR4nO2dC1ecRhSAEYiMDah1HUxjGg3xEW1tdF1dF5PWptZHtk3b//9nCuyyPObBBQdY3Pudk5MTBYb5lrmXO8MSTUMQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBJln1kNIs8011poier9uBxw0ZYmErW3/1lBrqui9NwMO1psibM3spqTvG6PDkm42mqLDknbWew0RSTpou9clIRsbyy9vmvtobzbMm5sXjTWniN7vywcN5uS112av11xzqlhf3mnuNknTdbO5xtTRqCRdXzG1Bj8TVaQk9V7UjB5g6sCN58llImn9vblcP9A2zDdzFLvSkt70SI3Y4YW0Yur6GmDj9e35lWTXyCDCDP7ohdtqcyzJP/ti1YzpAjb643CeJe3RpXp5Z0K2clESSkJJKAklCUFJAFASAJQEACUBQEkAUBIAlAQAJQF4oiTqupQ6Lni3RZTkDjcHmm/fXVjAHRdQkjvWSLg3IVcj2J6LJ8na9OPDEBslcaEXfnIccuWiJA7OIL3sA9t30STRMz99IHIIuZQWTZJzmV0/tC2UxPZkMycJhxuLk5eEw42F3mZj0hUONx6ZA5Gxg5I4XcmMN1uwVfaICydpydUTS/4F/0JyzjI/XzxJdHQ/DUuErPLDtjv299KWFk/SEqWXWvSkzNUZ35GzR4g9TB10ASUF3XH2xuPboWCmhI6C4xI9JXAhJQUiHIcK9qLUjiZS7hJLCypJ1te7yaH9zZmlLkuytRokWbNbBHIbW+quJKI/2uoluavJHTmJbwS6K8k2DM9WLck5y9xqTqd3uyvJMwzjmqiVREd2uhly73RbUt8I6auVlJ22DFOc1WFJu38aEwYqJVl3+Sf6/Uu3u5KWj6eStl6pk2Rd+kxLfpjiuilprQ5J7i3rKExxtKOStlKS3vbUSKJn3KZIkOJgkpwf5krSdUbSuaIryeZ/xYjcW1BJr+dHEukbGUnevgpFzr3oa1hBiuucJHJvVJIkv9zYxJZq8RIs6cc5kaQbVSTRh1PZbLZ7KXakaT0TMqAjSWuNeZBhG5UkjQxvX9xT54KX2Gb0TMm+WUm6LTtQU1xXk/QYbDsS/ZLuy9vsmTbgIZ1I0socWCKTaqSsJPdzWOk9CgYcFSW2mJ4JWZ+bStIbUiGEnBtVJDlHoSPD+8y3ZAkT25SeqfmHhZZiSS1bIgOjiiT64E029o54ltzDou9gB5I0f1y0ID6T1K4l26giiQ6NGQ9saHHH0qAdEkrSiGCNjiOp1bBkVJIUBe2YYd6Sc1H8Xf7e5A0TzL4iSW1a6leS5HxKOTIec7+lQ0DDE0nEFi2wMJJaG3Bx0C4paRq0Z3zKDBpK9eILKb6SCp6wTEtqydIsaJeT5JxmHQUpLt1T9wry4oyppIIUl5HUjiXdqCKJ7ht5vFR9YhUmtohYkiZ6eIAjqQ1LtlFJ0hLjKGBWY6TXj2TMJGlkT5zicpJaCN7XlSTRR1aRMatPnD3gS2oSSZotTnE5SY1bIv1sL4GSnM8eIyjkMeooKLFFpCSRAVhSwwMunEKqIIkJ2jGT+sSFJLaIlKR4lQkiqVFLRM/3MpB0UiiJE7RnloL6xJVMs+XaDwrcZDLN3xRYYiU1acnO9/H4ePnrcaGkYX63NA9fNmFBO2Bnx9zZSf4pSnEcSQ2GpfygOXkVvvhxci0Fkk74M2KCoB0zhr9oKv+eyXCVCSapMUv5oB1LevshxHj19dtfP/H4+4OMbwdwmDeW8qfgeJIaspSuRjKSdicEf//MY1cdjKT4QQqApEbCUqYayQ23kHC4/fOO5eFEil36ta6ZF6RyUxxfUhOWmKAdStpeDj7eSeTmB24qDdqGAU7+ISR68V/2LbLkkrUkkNSAJW4fo4vBkEhakgft83Kvg4wup9zP/FtmxIkk1R6WmKCdhyspO4XE0Ffyykwmp4ok1WyJE7QhktwjwZ32hGs152bn14SFkmodcLygDZAkrEamqDq7ewsqqU5LTDUCkkT35Y6UXfz57+9KJNVniZfYAJJG8h0GSgJSBBlbUEm1WbqW91YgqaAaKZnY5GRXmaSS6gnebDUCkiSaQpqiJrElpKfgpJJqsQRIbDxJBUFbTWJLnWV6lUkuqYYBx04hgSTNFrQFKP84yb0LlaTeEihos5KKqhHl5xmkOAsqSXnr8gtCJKkgaCtMbAnJgxSFktRaAgbtvCTnk9St0sSWOtl4lalYksrRDg3aOUn5Be0cfYVnmGWa4oolKbQEqUY4kgqCtqfs/JjznX5dFyBJ3YADB+2MpKIppBpL8emDFBBJqizZ4KCdkTQyPDGBo2r/2QQM/9CBSlJjiYCqEUYSfTiSsbpZL0OwJBWWygTtzJVEpTg1Ax5uKoI3s6ANltQ+QElPtwStRros6akDrlRiSyQ5zY4tARZU0hMtlQvasaSj0yyrLXEHlfQUSyWqkbSkrdzC4/laS6yAJVUPS2UT21TSx19yvGyPXaCkypZKVSMzTv79mOO7NvkP5qjygCsftCeWtrKstArUUVVLpaoRIQP4abZMBUVVgjaH87a7XoLyjqoEbZZ+2x0vQ9ngTQbyiVcg1233uxwlLZWuRrh4bfe6LOUkKXHUoaAdU8ZR+WrkeTgqYUlR0O5SYkuAOio7hcSnU4ktARi81QTtjiW2BJClitVInrb7Wh2IpMUN2jGFihRVI112VGhpoRNbgtyRmqDd0cSWIA3eaoK213Yfn47MkpoppLZ7qALxYMOgnYBBGwLfUaV5/2friG9pwasRFl7wVuLIa7tnKmEdqalG2u6XWjCxQcDEBiHtCKsRAangraYaeUaJLSGxpKQa8druTz2oDdpt96YuVAbt55bYEkJJWI0Uof0PYGQgEDMO/q4AAAAASUVORK5CYII=';
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

    return Scaffold(
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
      file = File(image!.path);
    });
    File imageFile = File(file.path);
    var fileContent = imageFile.readAsBytesSync();
    fileContentBase64 = base64.encode(fileContent);

    /*setState(() {
      if (file != null) {
        File _imageFilePicked = File(file.path);
      }
    });*/
    /*setState(() {
      this.file = file;
    });*/
    //image = handleUploadImage(_imageFilePicked);
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
              SimpleDialogOption(
                child: Text('Photo with Camera',
                    style: TextStyle(color: Colors.grey[900])),
                onPressed: handleTakePhoto,
              ),
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
          labelText: "Description/Price",
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

      salePost salepost = salePost(
        title: titleController.text,
        description: descriptionController.text,

        image: fileContentBase64,
        user: user,
        userimage: userimage,
        date: DateTime.now(),
        //price: priceController.text,

        //numberOfPeople: 20, //int.parse(numberOfPeopleController.text),
        eventId: uuid.v4(),
      );
      _db
          .collection('salePost')
          .doc(salepost.eventId)
          .set(salepost.createMap());
      try {
        _db
            .collection('users')
            .doc(salepost.user)
            .collection('posts')
            .doc(salepost.eventId)
            .set(salepost.createMap());
      } catch (e) {
        debugPrint(e.toString());
      }
      //service.saveEvent(newEvent);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SecondHandSaleScreen()));
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