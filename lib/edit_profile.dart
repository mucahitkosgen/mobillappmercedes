import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:mobilappmercedes/aboutpage/about_page.dart';
import 'package:mobilappmercedes/dashboard/screens/bottom_nav_screen.dart';
import 'package:mobilappmercedes/screens/feed_screen.dart';
import 'package:mobilappmercedes/screens/profile_screen.dart';
import 'package:mobilappmercedes/screens/profile_screen2.dart';
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  late Future<String> _dataFuture;
  FirebaseAuth auth = FirebaseAuth.instance;
  late File imageOnScreen;
  String url = "";
  late File _image;
  File? file;
  late String fileContentBase64;
  var uuid = Uuid();
  FirebaseFirestore _db = FirebaseFirestore.instance;

  bool isLoading = false;
  //String resim = "";
  var userData = {};
  //"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";
  @override
  void initState() {
    getImage();

    super.initState();

    //getImage();
    // 'data:image/png;base64,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';
    //fileContentBase64 =
    // 'data:image/png;base64,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';
  }

  @override
  void dispose() {
    super.dispose();
  }

  getImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      var firebaseUser = FirebaseAuth.instance.currentUser;

      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.email)
          .get();

      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      print("**Burada hata var");
    }
    setState(() {
      isLoading = false;
    });
  }
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance!.addPersistentFrameCallback((_) => baglantiAl());
  // }

  // baglantiAl() async {
  //   String baglanti = await FirebaseStorage.instance
  //       .ref()
  //       .child("profilePictures")
  //       .child(auth.currentUser!.uid)
  //       .child("profilePicture.png")
  //       .getDownloadURL();

  //   setState(() {
  //     url = baglanti;
  //   });
  // }

  Future _imgFromCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      file = File(image!.path);
    });
    File imageFile = File(file!.path);
    var fileContent = imageFile.readAsBytesSync();
    fileContentBase64 = base64.encode(fileContent);
    print('-----' + fileContentBase64);

    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.email)
        .set({
      "Photo": fileContentBase64,
    }, SetOptions(merge: true)).then((_) {
      print("success!");
    });
  }

  Future _imgFromGallery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);
    setState(() {
      file = File(image!.path);
    });
    File imageFile = File(file!.path);
    var fileContent = imageFile.readAsBytesSync();
    fileContentBase64 = base64.encode(fileContent);
    print('-----' + fileContentBase64);
    //resim = fileContentBase64;
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.email)
        .set({
      "Photo": fileContentBase64,
    }, SetOptions(merge: true)).then((_) {
      print("success!");
    });
  }

  late String kullaniciAdi, email, password;

  get profile => null;

  get veriYoluu => null;

  kullaniciAdiAl(kullaniciAdiTutucu) {
    kullaniciAdi = kullaniciAdiTutucu;
  }

  emailAl(emailTutucu) {
    email = emailTutucu;
  }

  passwordAl(passwordTutucu) {
    password = passwordTutucu;
  }

  bool isObscurePassword = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(

                // title: const Text("Edit Profile"),
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileScreen2();
                    }));
                  },
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AboutPage();
                        }));
                      },
                      child: Icon(Icons.info_outline_rounded),
                    ),
                  )
                ]),
            body: Container(
              padding: EdgeInsets.only(left: 15, top: 20, right: 15),
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            /* SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Image.memory(
                                  Base64Decoder().convert(userData['Photo']),
                                  fit: BoxFit.contain),
                            ),*/

                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 15,
                                      blurRadius: 20,
                                      color: Colors.grey.withOpacity(0.1))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(base64.decode(
                                          userData['Photo'].split(',').last))
                                      as ImageProvider,
                                  // MemoryImage(base64.decode(getImage().split(',').last)) as ImageProvider,

                                  // MemoryImage(base64.decode(fileContentBase64.split(',').last)) as ImageProvider,
                                  // 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Black_flag.svg/750px-Black_flag.svg.png'
                                  // fileContentBase64 == null ? AssetImage('assets/icons/logo3.png') :
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 15,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3, color: Colors.white),
                                    color: Colors.blue[900]),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  onPressed: () => _showPicker(context),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25, bottom: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String kullaniciAdiTutucu) {
                              kullaniciAdiAl(kullaniciAdiTutucu);
                            },
                            decoration: InputDecoration(
                              labelText: userData['KullaniciAdi'],
                              labelStyle: TextStyle(color: Colors.white24),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          onChanged: (String emailTutucu) {
                            emailAl(emailTutucu);
                          },
                          decoration: InputDecoration(
                            labelText: userData['Email'],
                            labelStyle: TextStyle(color: Colors.white24),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          onChanged: (String passwordTutucu) {
                            passwordAl(passwordTutucu);
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            labelStyle: TextStyle(color: Colors.white24),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                      ),

                      // ignore: deprecated_member_use
                      Container(
                        margin: const EdgeInsets.only(top: 25, bottom: 0),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                primary: Colors.blue[900],
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 85, vertical: 20)),
                            child: Text("Save"),
                            onPressed: _Save,
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          );
  }

  void _Save() async {
    DocumentReference veriYoluu =
        FirebaseFirestore.instance.collection("users").doc(email);

    Map<String, dynamic> profile = {
      "KullaniciAdi": kullaniciAdi,
      "Email": email,
      "Sifre": password,
      // "Photo": fileContentBase64,
    };

    veriYoluu.set(profile).whenComplete(() {});

    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? _yeniUser = _credential.user;
      await _yeniUser!.sendEmailVerification();
      if (_auth.currentUser != null) {
        debugPrint("Size bir mail attık lütfen onaylayın");
        await _auth.signOut();
        debugPrint("Kullanıcıyı sistemden attık");
      }

      debugPrint(_yeniUser.toString());
    } catch (e) {
      debugPrint("*HATA VAR*");
      debugPrint(e.toString());
    }
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                    onPressed: () {},
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }

  // image: fileContentBase64 == null ? AssetImage('assets/icons/logo3.png') : MemoryImage(base64.decode(getImage().split(',').last)) as ImageProvider,
//  db.collection("users").doc(userEmail).get().then((value){
//       print(value.data());

  void _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
/* var firebaseUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser!.email)
          .get()
          .then((value) {
        resim = value.data()!["Photo"];
        setState(() {});
      });*/