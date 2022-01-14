import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobilappmercedes/dashboard/screens/bottom_nav_screen.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 310,
            right: -350,
            //height: 100,
            //width: 100,
            child: Image.asset(
              "assets/images/yuvarlaklar.png",
              //width: size.width * 0.2,
            ),
          ),
          Positioned(
            top: 350,
            left: -400,
            //height: 1000,
            //width: 1000,
            child: Image.asset(
              "assets/images/lower-circles.png",
              //width: size.width * 0.2,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
