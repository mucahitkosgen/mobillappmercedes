import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilappmercedes/aboutpage/about_page.dart';
import 'package:mobilappmercedes/dashboard/screens/bottom_nav_screen.dart';
import 'package:mobilappmercedes/screens/profilpostflow.dart';
import 'package:mobilappmercedes/welcome/components/body.dart';
import 'package:mobilappmercedes/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:mobilappmercedes/dashboard/screens/screens.dart';
import 'package:mobilappmercedes/edit_profile.dart';
import 'package:mobilappmercedes/utils/text_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobilappmercedes/widgets/profile_widget/profile_detay.dart';
import 'package:mobilappmercedes/widgets/profile_widget/profile_widget.dart';

import '../edit_profile.dart';

class SuggestedLocationsPage extends StatefulWidget {
  @override
  _SuggestedLocationsPageState createState() => _SuggestedLocationsPageState();
}

class _SuggestedLocationsPageState extends State<SuggestedLocationsPage> {
  @override
  var firebaseUser = FirebaseAuth.instance.currentUser;
  late ScrollController scrollController;
  bool isLoading = false;
  var userData = {};
  void initState() {
    scrollController = ScrollController();

    getImage();

    super.initState();
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

  Widget build(BuildContext context) {
    // TODO: implement build
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            floatingActionButton: _fabButton,
            body: SafeArea(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.black,
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      leading: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              MemoryImage(base64.decode(userData['Photo']))
                                  as ImageProvider),
                      title: Text("Suggested Locations",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 1)),
                      toolbarHeight: 80,
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
                      ],
                    ),
                    _expandedlistview,
                  ],
                ),
              ),
            ),
          );
  }

  Widget get _fabButton => FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      );

  Widget get _expandedlistview => Expanded(child: _listview);

  Widget get _listview => ListView.builder(
      itemCount: 10,
      controller: scrollController,
      itemBuilder: (context, index) {
        return Text("data");
      });
  Widget get _listviewCard => Card();
}
