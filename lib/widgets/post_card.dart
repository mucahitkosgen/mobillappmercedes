import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:intl/intl.dart';
import 'package:mobilappmercedes/seconhandsale/sendmailscreen.dart';
var userData = {};
class PostCard extends StatelessWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _participants = 0;
    
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        MemoryImage(base64.decode(snap['userimage']))
                            as ImageProvider),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: snap['user'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                var mail = snap['user'];
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SendEmail(
                                        mail: mail,
                                      );
                                    }));
                                  }),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

// Image Session
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.memory(Base64Decoder().convert(snap['image']),
                fit: BoxFit.cover),
          ),

          //Like Coomand section
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  LikeButton(
                    onTap: onLikeButtonTapped,
                    circleColor: CircleColor(
                        start: Colors.redAccent, end: Colors.redAccent),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        size: 30,
                        color: isLiked ? Colors.redAccent : Colors.redAccent,
                      );
                    },
                  ),
                                          RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: snap['likes'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF2979FF),
                              )),
                          TextSpan(
                              text: ' likes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2979FF),
                              ))
                        ]),
                  ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 8, right: 15),
              //   child: Image.asset(
              //     "assets/icons/comment.png",
              //     color: Colors.white,
              //     width: 25,
              //     height: 25,
              //   ),
              // ),
              Row(
                children: <Widget>[
                IconButton(
          icon: const Icon(Icons.add),
          color: Colors.white,
          onPressed: () {
            showAlertDialog(context);
          },
        ),
        // Text("Join this event")
                ]
              ),
            ],
          ),
          // Description and numbrer of like
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: snap['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ))
                        ]),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8, left: 0),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: 'Event Description:' + ' ',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF2979FF),
                              )),
                          TextSpan(
                              text: snap['description'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ))
                        ]),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                        text: 'Date:' + ' ',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Color(0xFF2979FF),
                        )),
                    TextSpan(
                      text: DateFormat('dd/MM/yyyy HH:mm').format(
                        snap['to'].toDate(),
                      ),
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ]),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                     
                          TextSpan(children: [
                            TextSpan(
                                text: "Capacity:" " ",
                                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w900, color: Color(0xFF2979FF)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // katilimcilar(context);
                    //                                     Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return SendEmail();
                    // }));
                                  }),
                          ]),
                        
                    
                    TextSpan(
                      text:  snap['participants'].toString() + "/" + snap['numberOfPeople'].toString(),
                      
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ]),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.only(top: 5, left: 0),
          //   child: TextFormField(
          //     style: const TextStyle(color: Colors.white),
          //     decoration: const InputDecoration(
          //         hintText: 'Leave a comment',
          //         isDense: true, // important line
          //         contentPadding: EdgeInsets.fromLTRB(
          //             10, 10, 10, 0), // control your hints text size
          //         hintStyle: TextStyle(
          //           letterSpacing: 2,
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //           fontStyle: FontStyle.normal,
          //           fontSize: 14,
          //         ),
          //         fillColor: Colors.black,
          //         filled: true,
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: BorderSide(color: Colors.white, width: 1))),
          //   ),
          // ),

          Container(
            padding: const EdgeInsets.only(top: 5, left: 300),
            child: Text(
              DateFormat.yMMMd().format(
                snap['date'].toDate(),
              ),
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
  showAlertDialog(BuildContext context) {
    // int _participants = 0;
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed:  () async {
      if (snap["participants"] < snap["numberOfPeople"]) {
        var firebaseUser = FirebaseAuth.instance.currentUser;

    var userDocRef = FirebaseFirestore.instance
.collection('Events')
    .doc(snap['eventId'])
    .collection('katilimci')
    .doc(firebaseUser!.email);

  var doc = await userDocRef.get();
   if (!doc.exists) {
        FirebaseFirestore.instance
        .collection("Events")
        .doc(snap["eventId"])
        .update({
      "participants": snap["participants"] += 1 
        });
        FirebaseFirestore.instance
          .collection('Events')
          .doc(snap['eventId'])
          .collection('katilimci')
          .doc(firebaseUser!.email)
          .set({}
          );
          Navigator.of(context).pop();
   } else {
     alreadyAttending(context);
   }
      
      }else {
        showEventFullDialog(context);
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Attend"),
    content: Text("Would you like to attend this event?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
showEventFullDialog(BuildContext context){
    Widget exitButton = TextButton(
    child: Text("Ok"),
    onPressed:  () {
      int count = 0;
Navigator.of(context).popUntil((_) => count++ >= 2);
    },
  );
    AlertDialog alert = AlertDialog(
    title: Text("Sorry"),
    content: Text("This event is full."),
    actions: [
      exitButton,
    ],
  );
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
alreadyAttending(BuildContext context){
    Widget exitButton = TextButton(
    child: Text("Close"),
    onPressed:  () {
      int count = 0;
Navigator.of(context).popUntil((_) => count++ >= 2);
    },
  );
      Widget deleteEvent = TextButton(
    child: Text("Remove me from this event"),
    onPressed:  () {
      var firebaseUser = FirebaseAuth.instance.currentUser;
          FirebaseFirestore.instance
          .collection('Events')
          .doc(snap['eventId'])
          .collection('katilimci')
          .doc(firebaseUser!.email)
          .delete(
          );
        FirebaseFirestore.instance
        .collection("Events")
        .doc(snap["eventId"])
        .update({
      "participants": snap["participants"] -= 1 
        });
      int count = 0;
Navigator.of(context).popUntil((_) => count++ >= 2);
    },
  );
    AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text("You already attending this event."),
    actions: [
      exitButton,
      deleteEvent,
    ],
  );
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

katilimcilar(BuildContext context) async {
     Widget exitButton = TextButton(
    child: Text("Close"),
    onPressed:  () {
Navigator.of(context).pop();
    },
  );
      var firebaseUser = FirebaseAuth.instance.currentUser;

 var userDocRef = FirebaseFirestore.instance
.collection('Events')
    .doc(snap['eventId'])
    .collection('katilimci');
    

 String mail = userDocRef.path.split("/")[3];
//     userData = userSnap.data()!;
    

      AlertDialog alert = AlertDialog(
    title: Text("Katilimcilar"),
    content: Text(mail),
    actions: [
      exitButton,
    ],
  );
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    // var firebaseUser = FirebaseAuth.instance.currentUser;

    if (isLiked = true) {
        var firebaseUser = FirebaseAuth.instance.currentUser;

    var userDocRef = FirebaseFirestore.instance
.collection('Events')
    .doc(snap['eventId'])
    .collection('liked_users')
    .doc(firebaseUser!.email);

  var doc = await userDocRef.get();
   if (!doc.exists) {
        FirebaseFirestore.instance
        .collection("Events")
        .doc(snap["eventId"])
        .update({
      "likes": snap["likes"] += 1 
        });
        FirebaseFirestore.instance
          .collection('Events')
          .doc(snap['eventId'])
          .collection('liked_users')
          .doc(firebaseUser!.email)
          .set({}
          );
          return true;
   }else{
     return true;
   }
    } return true;
  }
}
