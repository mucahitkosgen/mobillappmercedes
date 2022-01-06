// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilappmercedes/screens/feed_screen.dart';
import 'package:mobilappmercedes/screens/home_screen.dart';
import 'package:mobilappmercedes/screens/likes_screen.dart';
import 'package:mobilappmercedes/screens/profile_screen.dart';
import 'package:mobilappmercedes/screens/search_screen.dart';
import 'package:mobilappmercedes/utils/text_utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  final TextUtils _textUtils = TextUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: showAppBar(),
      body: getScreen(),
      bottomNavigationBar: bottomBarWidget(),
    );
  }

  Widget bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              index = 0;
              setState(() {});
            },
            child: Image.asset(
                index == 0
                    ? "assets/icons/home_filled.png"
                    : "assets/icons/home.png",
                color: Colors.white,
                width: 25,
                height: 25),
          ),
          Image.asset("assets/icons/add_post.png",
              color: Colors.white, width: 25, height: 25),
          InkWell(
            onTap: () {
              index = 3;
              setState(() {});
            },
            child: Image.asset(
                index == 3
                    ? "assets/icons/information.png"
                    : "assets/icons/information.png",
                width: 30,
                height: 30),
          ),
          InkWell(
            onTap: () {
              index = 4;
              setState(() {});
            },
            child: Image.asset(
                index == 3 ? "assets/icons/logo.png" : "assets/icons/logo.png",
                color: Colors.white,
                width: 25,
                height: 25),
          ),
        ],
      ),
    );
  }

  Widget getScreen() {
    switch (index) {
      case 0:
        return const FeedScreen();

      case 2:
        return const FeedScreen();

      case 3:
        return const LikesScreen();

      case 4:
        return const ProfileScreen();

      default:
        return Container();
    }
  }

  AppBar showAppBar() {
    switch (index) {
      case 0:
        return AppBar(
          backgroundColor: Colors.lightBlue[900],
          elevation: 0.0,
          title: const Text(
            "Events",
            style: TextStyle(fontFamily: 'FontSpring', fontSize: 26),
          ),
        );

      case 1:
      case 3:
        return AppBar(
          toolbarHeight: 0.0,
          backgroundColor: Colors.black,
        );

      case 4:
        return AppBar(
          toolbarHeight: 0.0,
          backgroundColor: Colors.black,
        );

      default:
        return AppBar(
          toolbarHeight: 0.0,
        );
    }
  }
}
