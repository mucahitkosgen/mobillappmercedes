import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilappmercedes/Components/rounded_button.dart';
import 'package:mobilappmercedes/aboutpage/about_page.dart';
/*import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Welcome/components/background.dart';

import 'package:mobilappmercedes/components/rounded_button.dart'; 
import 'package:flutter_auth/constants.dart';*/

import 'package:mobilappmercedes/createAccount.dart';
import 'package:mobilappmercedes/dashboard.dart';
import 'package:mobilappmercedes/dashboard/screens/bottom_nav_screen.dart';
import 'package:mobilappmercedes/edit_profile.dart';
import 'package:mobilappmercedes/login.dart';
import 'package:mobilappmercedes/welcome/components/background.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
                        Padding(
                          
                          padding: EdgeInsets.only(left: 300.0, bottom: 130),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AboutPage();
                              }));
                            },
                            child: Icon(Icons.info_outline_rounded),
                          ),
                        ),
                      
            Text(
              "",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SvgPicture.asset(
              "assets/icons/Discover theMercedesMedia.svg",
              height: size.height * 0.25,
            ),
            SizedBox(height: size.height * 0.1),
            RoundedButton(
              text: "LOGIN",
              color: Colors.blue,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (_auth.currentUser != null) {
                        return BottomNavScreen();
                      } else {
                        // return LoginIslemleri();
                        return LoginIslemleri();
                      }
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: Colors.purple,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AccountIslemleri();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
