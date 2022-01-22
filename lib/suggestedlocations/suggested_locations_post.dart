import 'package:flutter/material.dart';

class LocationsPost {
  final String eventId;
  final String title;
  final String description;

  final String user;
  final String userimage;
  final String image;
  final DateTime date;
  //final Color backgroundColor;

  //final String price;

  const LocationsPost({
    required this.eventId,
    required this.title,
    required this.description,
    //required this.price,
    required this.user,
    required this.userimage,
    required this.image,
    required this.date,
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
      //'backgroundColor': backgroundColor
    };
  }

  LocationsPost.fromFirestore(Map<String, dynamic> firestoreMap)
      : eventId = firestoreMap['eventId'],
        title = firestoreMap['title'],
        // price = firestoreMap['price'],
        user = firestoreMap['user'],
        userimage = firestoreMap['userimage'],
        image = firestoreMap['image'],
        date = firestoreMap['date'],
        //backgroundColor = firestoreMap['backgroundColor'],

        description = firestoreMap['description'];
}
