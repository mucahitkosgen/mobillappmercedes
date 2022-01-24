import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilappmercedes/dashboard/screens/home_screen.dart';
import 'package:mobilappmercedes/dashboard/screens/bottom_nav_screen.dart';
import 'package:mobilappmercedes/dashboard/screens/screens.dart';
import 'package:mobilappmercedes/screens/main_screen.dart';
import 'package:mobilappmercedes/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BottomNavScreen();
            }));
          },
        ),
        title: Text("Event"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Events')
            .orderBy('date',descending: true)
            // .limitToLast(15)
            
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
              itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ));
        },
      ),
    );
  }
}
