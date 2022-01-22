import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilappmercedes/aboutpage/about_page.dart';
import 'package:mobilappmercedes/dashboard/screens/bottom_nav_screen.dart';
import 'package:mobilappmercedes/screens/profilpostflow.dart';
import 'package:mobilappmercedes/suggestedlocations/suggested_locations_edit.dart';
import 'package:mobilappmercedes/suggestedlocations/suggested_locations_widget.dart';
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

class SuggestedLocationsScreen extends StatefulWidget {
  @override
  _SuggestedLocationsScreenState createState() =>
      _SuggestedLocationsScreenState();
}

class _SuggestedLocationsScreenState extends State<SuggestedLocationsScreen> {
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

  @override
  Widget build(BuildContext context) {
    //"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";

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: MemoryImage(base64.decode(userData["Photo"]))
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
            backgroundColor: Colors.black,
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('SuggestedLocationsPost')
                  .orderBy('date', descending: true)
                  .limitToLast(15)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => SuggestedLocationsWidget(
                          snap: snapshot.data!.docs[index].data(),
                        ));
              },
            ),
          );
  }
}




/*

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
  */













/*AppBar(
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
*/