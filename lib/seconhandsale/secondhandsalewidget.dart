import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:mobilappmercedes/config/styles.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:intl/intl.dart';
import 'package:mobilappmercedes/seconhandsale/sendmailscreen.dart';

class SaleWidget extends StatelessWidget {
  final snap;
  const SaleWidget({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

                      // Text(
                      //   snap['user'],
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.white,
                      //     fontSize: 15,
                      //   ),
                      // ),
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
                    likeBuilder: (isLiked) {
                      return Icon(
                        Icons.favorite,
                        size: 27,
                        color: isLiked? Colors.redAccent : Colors.redAccent,
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
              )
            ],
          ),
          // Description and numbrer of like
          Container(
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
                              text: 'Product:' + ' ',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF2979FF),
                              )),
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
                              text: 'Price:' + ' ',
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
              //  Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.only(top: 8, left: 0),
              //     child: RichText(
              //       text: TextSpan(
              //           style: const TextStyle(color: Colors.white),
              //           children: [
              //             TextSpan(
              //                 text: 'Likes:' + ' ',
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.w900,
              //                   fontSize: 16,
              //                   color: Color(0xFF2979FF),
              //                 )),
              //             TextSpan(
              //                 text: snap['likes'].toString(),
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 14,
              //                 ))
              //           ]),
              //     ),
              //   ),                
              ],
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
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    // var firebaseUser = FirebaseAuth.instance.currentUser;

    if (isLiked = true) {
        var firebaseUser = FirebaseAuth.instance.currentUser;

    var userDocRef = FirebaseFirestore.instance
.collection('salePost')
    .doc(snap['eventId'])
    .collection('liked_users')
    .doc(firebaseUser!.email);

  var doc = await userDocRef.get();
   if (!doc.exists) {
        FirebaseFirestore.instance
        .collection("salePost")
        .doc(snap["eventId"])
        .update({
      "likes": snap["likes"] += 1 
        });
        FirebaseFirestore.instance
          .collection('salePost')
          .doc(snap['eventId'])
          .collection('liked_users')
          .doc(firebaseUser!.email)
          .set({}
          );
          return true;
   }else{
     return false;
   }
    } return true;
  }
}
