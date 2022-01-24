import 'package:flutter/material.dart';

class salePost {
  final String eventId;
  final String title;
  final String description;

  final String user;
  final String userimage;
  final String image;
  final DateTime date;
  final int likes;
  //final Color backgroundColor;

  //final String price;

  const salePost({
    required this.eventId,
    required this.title,
    required this.description,
    //required this.price,
    required this.user,
    required this.userimage,
    required this.image,
    required this.date,
    required this.likes,
    // this.backgroundColor = Colors.lightGreen,
  });

  Map<String, dynamic> createMap() {
    return {
      'eventId': eventId,
      'title': title,
      'description': description,

      //'price': price,

      'user': user,
      'userimage': userimage,
      'image': image,
      'date': date,
      'likes': likes,
      //'backgroundColor': backgroundColor
    };
  }

  salePost.fromFirestore(Map<String, dynamic> firestoreMap)
      : eventId = firestoreMap['eventId'],
        title = firestoreMap['title'],
        // price = firestoreMap['price'],
        user = firestoreMap['user'],
        userimage = firestoreMap['userimage'],
        image = firestoreMap['image'],
        date = firestoreMap['date'],
        //backgroundColor = firestoreMap['backgroundColor'],
        likes = firestoreMap['likes'],
        description = firestoreMap['description'];
}
