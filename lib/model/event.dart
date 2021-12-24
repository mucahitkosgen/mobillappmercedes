import 'package:flutter/material.dart';

class Event {
  final String eventId;
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  //final Color backgroundColor;

  final bool limitedParticipation;
  final int numberOfPeople;

  const Event({
    required this.eventId,
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.numberOfPeople,
    // this.backgroundColor = Colors.lightGreen,
    required this.limitedParticipation,
  });

  Map<String, dynamic> createMap() {
    return {
      'eventId': eventId,
      'title': title,
      'description': description,
      'from': from,
      'to': to,
      'numberOfPeople': numberOfPeople,
      'limitedParticipation': limitedParticipation,
      //'backgroundColor': backgroundColor
    };
  }

  Event.fromFirestore(Map<String, dynamic> firestoreMap)
      : eventId = firestoreMap['eventId'],
        title = firestoreMap['title'],
        from = firestoreMap['from'],
        to = firestoreMap['to'],
        numberOfPeople = firestoreMap['numberOfPeople'],
        //backgroundColor = firestoreMap['backgroundColor'],
        limitedParticipation = firestoreMap['limitedParticipation'],
        description = firestoreMap['description'];
}
