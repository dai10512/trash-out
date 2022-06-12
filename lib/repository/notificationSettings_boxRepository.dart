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
    box.add(todayNotification).then(
          (value) => box.add(tomorrowNotification).then(
                (value) => print('added default NotificationSetting'),
                onError: (e) => print("$e}"),
              ),
        );
  }

  NotificationSetting getNotificationSetting(int index) {
    final notificationSetting = box.getAt(index);
    return notificationSetting;
  }

  List<NotificationSetting> getNotificationSettings() {
    List<NotificationSetting> notificationSettings = box.values.toList().cast<NotificationSetting>();
    return notificationSettings;
  }

  Future<void> writeTime(int index, TimeOfDay time) async {
    print(time);
    final NotificationSetting notificationSetting = box.getAt(index);
    box
        .putAt(
          index,
          notificationSetting.copyWith(time: time),
        )
        .then(
          (value) => print('write time:${notificationSetting.time}'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> writeDoNotify(int index, bool doNotify) async {
    final NotificationSetting notificationSetting = box.getAt(index);
    box
        .putAt(
          index,
          notificationSetting.copyWith(doNotify: doNotify),
        )
        .then(
          (value) => print('write doNotify:${notificationSetting.doNotify}'),
          onError: (e) => print("$e}"),
        );
  }
}
