import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobilappmercedes/createAccount.dart';
import 'package:mobilappmercedes/login.dart';
import 'components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobilappmercedes/createAccount.dart';
import 'package:mobilappmercedes/dialogs/policy_dialog.dart';
import 'package:mobilappmercedes/dialogs/terms_and_conditions_dialog.dart';
import 'package:mobilappmercedes/login.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'components/rounded_button.dart';
import 'package:mobilappmercedes/dialogs/policy_dialog.dart';
import 'package:mobilappmercedes/dialogs/terms_and_conditions_dialog.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class AccountIslemleri extends StatefulWidget {
  @override
  _AccountIslemleriState createState() => _AccountIslemleriState();
}

class _AccountIslemleriState extends State<AccountIslemleri> {
  late String kullaniciAdi, email, password;
  late bool _checkbox = true;

  // ignore: unnecessary_getters_setters
  bool get checkbox => _checkbox;

  set checkbox(bool checkbox) {
    _checkbox = checkbox;
  }

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
    // TODO: implement initState
    super.initState();
    /*  _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('Kullanıcı Oturumu Kapattı');
      } else {
        print('Kullaıcı oturumu Açtı');
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        icon: Icon(Icons.account_circle, color: Colors.black),
                      ),
                      onChanged: (String kullaniciAdiTutucu) {
                        kullaniciAdiAl(kullaniciAdiTutucu);
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
              text: "Create Account",
              color: Colors.purple,
              press: _emailSifreKullaniciolustur,
            ),
            /*RoundedButton(
              text: "Forgot Password",
              color: Colors.blueAccent,
              press: _resetPassword,
            ),*/
            Padding(
              padding: const EdgeInsets.only(left: 20), //
              child: Row(
                children: [
                  Checkbox(
                    side: BorderSide(
                      // ======> CHANGE THE BORDER COLOR HERE <======
                      color: Colors.blue,
                      // Give your checkbox border a custom width
                      width: 1.5,
                    ),
                    value: _checkbox,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        _checkbox = !_checkbox;
                      });
                    },
                  ),
                  Text.rich(
                    TextSpan(
                        text:
                            "By creating an account, you are agreeing to our\n",
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: "       Terms & Conditions ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return TermsAndConditionsDialog(
                                        mdFileName: 'terms_and_conditions.md',
                                      );
                                    },
                                  );
                                }),
                          TextSpan(
                            text: "and",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                              text: " Privacy Policy",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PolicyDialog(
                                        mdFileName: 'privacy_policy.md',
                                      );
                                    },
                                  );
                                })
                        ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _emailSifreKullaniciolustur() async {
    // String _email = "e160503138@stud.tau.edu.tr";
    /// String _password = "abc123";
    DocumentReference veriYolu =
        FirebaseFirestore.instance.collection("users").doc(email);

    Map<String, dynamic> users = {
      "KullaniciAdi": kullaniciAdi,
      "Email": email,
      "Sifre": password,
      "Photo":
          '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',
    };

    veriYolu.set(users).whenComplete(() {});

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

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginIslemleri()));
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
