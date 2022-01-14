import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilappmercedes/seconhandsale/secondhandsalescreen.dart';
import 'package:mobilappmercedes/widgets/post_card.dart';
import 'package:mobilappmercedes/screens/feed_screen.dart';
import 'package:mobilappmercedes/screens/profile_screen.dart';
import 'package:mobilappmercedes/screens/profile_screen2.dart';
import 'package:mobilappmercedes/utils/text_utils.dart';
import 'package:mobilappmercedes/dashboard/screens/screens.dart';

class SecondHandSaleMain extends StatefulWidget {
  const SecondHandSaleMain({Key? key}) : super(key: key);

  @override
  _SecondHandSaleMainState createState() => _SecondHandSaleMainState();
}

class _SecondHandSaleMainState extends State<SecondHandSaleMain> {
  int index = 0;
  final List _screens = [
    SecondHandSaleScreen(),
    ProfileScreen2(),
    SecondHandSaleEdit(),
    Scaffold(),
  ];
  int _currentIndex = 0;

  final TextUtils _textUtils = TextUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: bottomBarWidget(),
    );
  }

  Widget bottomBarWidget() {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: [
          Icons.home,
          Icons.supervisor_account_rounded,
          Icons.add_box,
          Icons.info
        ]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    title: Text(''),
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: _currentIndex == key
                            ? Colors.blue[600]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(value),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
