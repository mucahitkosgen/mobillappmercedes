// ignore: file_names
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

FirebaseAuth _auth = FirebaseAuth.instance;

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
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
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Black_flag.svg/750px-Black_flag.svg.png'))),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: Colors.blue),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onChanged: (String kullaniciAdiTutucu) {
                      kullaniciAdiAl(kullaniciAdiTutucu);
                    },
                    decoration: InputDecoration(
                        labelText: "Kullanıcı Adı",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black54, width: 2))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onChanged: (String emailTutucu) {
                      emailAl(emailTutucu);
                    },
                    decoration: InputDecoration(
                        labelText: "Email",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black54, width: 2))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onChanged: (String passwordTutucu) {
                      passwordAl(passwordTutucu);
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                    ),
                  ),
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                  child: Text("Save"),
                  color: Colors.blueAccent,
                  onPressed: _Save,
                ),
              ],
            )),
      ),
    );
  }

  void _Save() async {
    DocumentReference veriYoluu =
        FirebaseFirestore.instance.collection("profile").doc(kullaniciAdi);

    Map<String, dynamic> profile = {
      "KullaniciAdi": kullaniciAdi,
      "Email": email,
      "Sifre": password,
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
      debugPrint("*******HATA VAR***");
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
}
