import 'package:flutter/material.dart';
import 'package:mobilappmercedes/dashboard/screens/screens.dart';
import 'package:mobilappmercedes/edit_profile.dart';
import 'package:mobilappmercedes/utils/text_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final TextUtils _textUtils = TextUtils();

  late TabController tabController;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  var userData = {};
  @override
  void initState() {
    getImage();
    super.initState();

    tabController = TabController(length: 2, vsync: this);
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
      print("****Burada hata var");
    }
    setState(() {
      isLoading = false;
    });
  }

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
        title: Text("Profil"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/icons/logo3.png",
                            color: Colors.white,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          _textUtils.normal14(
                              "Mercedes Media Official", Colors.white)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      child: Text("Edit Profile"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editProfile()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              //  child: Row(
              //  children: [
              //  Expanded(
              //  flex: 8,
              //child: TextButton(
              //onPressed: () {
              //Navigator.push(
              //  context,
              //MaterialPageRoute(
              //  builder: (context) => editProfile()));
              //  },
              //   child: const Text('Edit Profil'),
              //   ),
              //  ),
              //  const SizedBox(
              //    width: 10,
              // ),
              //  ],
              // ),
              // ),
              Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        flex: 9,
                      ),
                      const Expanded(
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
                          size: 18,
                        ),
                        flex: 1,
                      )
                    ],
                  )),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    GridView.count(
                      controller: scrollController,
                      crossAxisCount: 3,
                      children: [
                        for (int i = 0; i < 9; i++)
                          Container(
                            margin: const EdgeInsets.only(right: 3, top: 3),
                            child: Image.asset(
                              "assets/images/f1.jpg",
                              fit: BoxFit.cover,
                            ),
                          )
                      ],
                    ),
                    GridView.count(
                      controller: scrollController,
                      crossAxisCount: 3,
                      children: [
                        for (int i = 0; i < 9; i++)
                          Container(
                            margin: const EdgeInsets.only(right: 3, top: 3),
                            child: Image.asset(
                              "assets/images/f1.jpg",
                              fit: BoxFit.cover,
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget favouriteStoriesWidget() {
    return const Padding(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: CircleAvatar(
        radius: 33,
        backgroundColor: Color(0xFF3E3E3E),
      ),
    );
  }
}
