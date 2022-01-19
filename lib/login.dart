import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
//<<<<<<< HEAD
import 'package:mobilappmercedes/dashboard.dart';
import 'package:mobilappmercedes/edit_profile.dart';

///=======
import 'package:mobilappmercedes/dashboard/screens/screens.dart';
//>>>>>>> 8e7617bf88fa3eb78c9a781e1d9fed6cfeb3f19a

import 'aboutpage/about_page.dart';
import 'components/rounded_button.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginIslemleri extends StatefulWidget {
  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  late String kullaniciAdi, email, password;

  get users => null;

  get veriYolu => null;

  kullaniciAdiAl(kullaniciAdiTutucu) {
    this.kullaniciAdi = kullaniciAdiTutucu;
  }

  emailAl(emailTutucu) {
    this.email = emailTutucu;
  }

  passwordAl(passwordTutucu) {
    this.password = passwordTutucu;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFF2979FF)),
          automaticallyImplyLeading: true,
          elevation: 4,
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AboutPage();
                  }));
                },
                child: Icon(Icons.info_outline_rounded),
              ),
            )
          ]),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.0010,
            ),
            SvgPicture.asset(
              "assets/images/dis.svg",
              height: size.height * 0.25,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(7.0),
                width: size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.1,
                      color: Colors.black45,
                      spreadRadius: 0.5,
                      offset: Offset(
                        1.5,
                        2,
                      ),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 30,
                    child: TextFormField(
                      style: TextStyle(color: Colors.purple),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'E-mail',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        icon: Icon(Icons.alternate_email_rounded,
                            color: Colors.black),
                      ),
                      onChanged: (String emailTutucu) {
                        emailAl(emailTutucu);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(7.0),
                width: size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.1,
                      color: Colors.black45,
                      spreadRadius: 0.5,
                      offset: Offset(
                        1.5,
                        2,
                      ),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 30,
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(color: Colors.purple),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        icon: Icon(Icons.password_rounded, color: Colors.black),
                      ),
                      onChanged: (String passwordTutucu) {
                        passwordAl(passwordTutucu);
                      },
                    ),
                  ),
                ),
              ),
            ),
            RoundedButton(
                text: "LOGIN",
                color: Colors.purple,
                press: () async {
                  try {
                    User? _oturumAcanUser =
                        (await _auth.signInWithEmailAndPassword(
                                email: email, password: password))
                            .user;
                    if (_oturumAcanUser!.emailVerified) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavScreen()));

                      debugPrint("Mail onaylı ana sayfaya gidilebilir");
                    } else {
                      debugPrint("Oturum açmış kullanıcı zaten var");
                    }
                  } catch (e) {
                    debugPrint("**HATA VAR**");
                    debugPrint(e.toString());
                  }
                }),
            RoundedButton(
              text: "FORGOT PASSWORD",
              color: Colors.blue,
              textColor: Colors.black,
              press: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }

  void _emailSifreKullaniciolustur() async {
    // String _email = "e160503138@stud.tau.edu.tr";
    /// String _password = "abc123";
    DocumentReference veriYolu =
        FirebaseFirestore.instance.collection("users").doc(kullaniciAdi);

    Map<String, dynamic> users = {
      "KullaniciAdi": kullaniciAdi,
      "Email": email,
      "Sifre": password,
    };

    veriYolu.set(users).whenComplete(() {});

    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? _yeniUser = _credential.user;
      await _yeniUser!.sendEmailVerification();
      if (_auth.currentUser != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Size mail attık"),
                actions: [
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        debugPrint("Size bir mail attık lütfen onaylayın");
        await _auth.signOut();
        debugPrint("Kullanıcıyı sistemden attık");
      }

      debugPrint(_yeniUser.toString());
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.toString()),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      debugPrint("**HATA VAR**");
      debugPrint(e.toString());
    }
  }

  void _cikisYap() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    } else {
      debugPrint("Zaten oturum açmış bir kullanıcı yok");
    }
  }

  void _resetPassword() async {
    String _email = email;

    try {
      await _auth.sendPasswordResetEmail(email: _email);
      debugPrint("Resetleme maili gönderildi");
    } catch (e) {
      debugPrint("Şifre resetlenirken hata $e");
    }
  }
}
