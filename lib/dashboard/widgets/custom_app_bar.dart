import 'package:flutter/material.dart';
import 'package:mobilappmercedes/config/palette.dart';
import 'package:mobilappmercedes/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobilappmercedes/dashboard/screens/bottom_nav_screen.dart';
import 'package:mobilappmercedes/welcome/welcome_screen.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    void _cikisYap() async {
      if (_auth.currentUser != null) {
        await _auth.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WelcomeScreen();
        }));
      } else {
        debugPrint("Zaten oturum açmış bir kullanıcı yok");
      }
    }

    return AppBar(
      backgroundColor: Palette.bprimaryColor,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.power_settings_new),
        iconSize: 28.0,
        onPressed: _cikisYap,
      ),
      actions: <Widget>[],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
