import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'notificationSetting.g.dart';

@HiveType(typeId: 2)
class NotificationSetting {
  @HiveField(0)
  int whichDay;

  @HiveField(1)
  TimeOfDay time;

  @HiveField(2)
  bool doNotify;

  NotificationSetting({
    required this.whichDay,
    required this.time,
    required this.doNotify,
  });

  NotificationSetting copyWith({
    TimeOfDay? time,
    bool? doNotify,
  }) {
    return NotificationSetting(
      whichDay: whichDay,
      time: time ?? this.time,
      doNotify: doNotify ?? this.doNotify,
    );
  }
}
