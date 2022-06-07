import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/typeAdapter/notificationSetting.dart';

NotificationSettingsBoxRepository notificationSettingsBoxRepository = NotificationSettingsBoxRepository();

class NotificationSettingsBoxRepository {
  Box<dynamic> box = Hive.box<NotificationSetting>('NotificationSetting');

  void isFirst() {
    if (box.isEmpty) {
      initNotificationSettings();
    }
  }

  void initNotificationSettings() {
    final todayNotification = NotificationSetting(
      whichDay: 0,
      time: const TimeOfDay(hour: 8, minute: 00),
      doNotify: false,
    );
    final tomorrowNotification = NotificationSetting(
      whichDay: 1,
      time: const TimeOfDay(hour: 21, minute: 00),
      doNotify: false,
    );
    box.add(todayNotification);
    box.add(tomorrowNotification).then((value) => print('added default NotificationSetting'));
  }

  NotificationSetting getNotificationSetting(int index) {
    final NotificationSetting = box.getAt(index);
    return NotificationSetting;
  }

  List<NotificationSetting> getNotificationSettings() {
    List<NotificationSetting> notificationSettings = box.values.toList().cast<NotificationSetting>();
    return notificationSettings;
  }

  void writeTime(int index, TimeOfDay time) {
    print(time);
    final NotificationSetting notificationSetting = box.getAt(index);
    box.putAt(index, notificationSetting.copyWith(time: time)).then((value) => print('write time'));
    print(notificationSetting.time);
  }

  void writeDoNotify(int index, bool doNotify) {
    final NotificationSetting notificationSetting = box.getAt(index);
    box
        .putAt(
            index,
            notificationSetting.copyWith(
              doNotify: doNotify,
            ))
        .then((value) => print('write doNotify'))
        .then((value) => print(notificationSetting.doNotify));
  }
}





