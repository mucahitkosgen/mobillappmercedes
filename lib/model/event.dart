import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;
  final bool limitedParticipation;
  final int numberOfPeople;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.numberOfPeople,
    this.backgroundColor = Colors.lightGreen,
    this.isAllDay = false,
    this.limitedParticipation = false,
  });
}
