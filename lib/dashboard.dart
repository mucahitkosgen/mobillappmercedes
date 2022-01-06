import 'package:flutter/material.dart';
import 'package:mobilappmercedes/screens/feed_screen.dart';
import 'package:mobilappmercedes/widgets/calendar_widget/calendar.dart';
import 'package:mobilappmercedes/dashboard.dart';
import 'package:mobilappmercedes/event_editing.dart';
import 'package:mobilappmercedes/screens/main_screen.dart';
import 'package:mobilappmercedes/screens/profile_screen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: size.height * .3,
              width: size.width * 1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage("assets/dashboard/ust_sablon.png")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(children: [
                const Expanded(
                  flex: 2,
                  child: Text("Mercedes Media",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      )),
                ),
                Expanded(
                    flex: 2,
                    child: IconButton(
                        onPressed: () {},
                        alignment: Alignment.topRight,
                        icon: const Icon(
                          Icons.info,
                          color: Colors.white,
                        ))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 70, right: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen();
                  }));
                },
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1))
                                ],
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://www.pngfind.com/pngs/m/676-6764065_default-profile-picture-transparent-hd-png-download.png'))),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 150, right: 15),
              child: Row(children: [
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Event_Editing()));
                    },
                    child: const Text('Create Event'),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Calendar()));
                        },
                        child: const Text(
                          'Calendar',
                        ))),
              ]),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 330, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedScreen()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0xFFF5F5F5),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/dashboard/Second_Hand_Sale_Button.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const Text(
                                '         \n       Second \n         Hand \n          Sale',
                                style: TextStyle(color: Colors.grey))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(70, 0, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()));
                        },
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/dashboard/Suggested_Location_Button.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              const Text(
                                  '     \n    \n    Suggested\n      Location',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 450, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0xFFFF0000),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/dashboard/Limited_Participation_Button.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const Text('\n\n     Limitited \n   Particiption',
                                style: TextStyle(color: Colors.grey))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(70, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/dashboard/Events_Button.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const Text('\n\n       Events',
                                style: TextStyle(color: Colors.grey))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
