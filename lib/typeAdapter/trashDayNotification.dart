import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'trashDayNotification.g.dart';

@HiveType(typeId: 2)
class TrashDayNotification {
  @HiveField(0)
  int whichDay;

  @HiveField(1)
  TimeOfDay time;

  @HiveField(2)
  bool doNotify;

  TrashDayNotification({
    required this.whichDay,
    required this.time,
    required this.doNotify,
  });

  TrashDayNotification copyWith({
    TimeOfDay? time,
    bool? doNotify,
  }) {
    return TrashDayNotification(
      whichDay: whichDay,
      time: time ?? this.time,
      doNotify: doNotify ?? this.doNotify,
    );
  }
}
