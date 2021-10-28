import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('Kullanıcı Oturumu Kapattı');
      } else {
        print('Kullaıcı oturumu Açtı');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login işlemleri"),
      ),
      body: Center(
        child: Column(
          children: [
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
            RaisedButton(
              child: Text("Email/Sifre User Create"),
              color: Colors.blueAccent,
              onPressed: _emailSifreKullaniciolustur,
            ),
            RaisedButton(
              child: Text("Email/Sifre User Login"),
              color: Colors.blueAccent,
              onPressed: _emailSifreKullaniciGirisYap,
            ),
            RaisedButton(
              child: Text("Şifremi Unuttum"),
              color: Colors.blueAccent,
              onPressed: _resetPassword,
            ),
            RaisedButton(
              child: Text("Çıkış Yap"),
              color: Colors.blueAccent,
              onPressed: _cikisYap,
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

  void _emailSifreKullaniciGirisYap() async {
    // String _email = "e160503138@stud.tau.edu.tr";
    // String _password = "abc456";
    try {
      if (_auth.currentUser == null) {
        User? _oturumAcanUser = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
        if (_oturumAcanUser!.emailVerified) {
          debugPrint("Mail onaylı ana sayfaya gidilebilir");
        } else {
          debugPrint("Lütfen mailinizi onaylayıp tekrar giriş yapınız");
          _auth.signOut();
        }
      } else {
        debugPrint("Oturum açmış kullanıcı zaten var");
      }
    } catch (e) {
      debugPrint("*******HATA VAR***");
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
    String _email = "e160503138@stud.tau.edu.tr";

    try {
      await _auth.sendPasswordResetEmail(email: _email);
      debugPrint("Resetleme maili gönderildi");
    } catch (e) {
      debugPrint("Şifre resetlenirken hata $e");
    }
  }
}
