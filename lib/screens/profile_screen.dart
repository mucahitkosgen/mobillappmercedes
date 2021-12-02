import 'package:flutter/material.dart';
import 'package:mobilappmercedes/utils/text_utils.dart';

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

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(9),
                        child: Center(
                          child:
                              _textUtils.normal16("Edit Profile", Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
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
