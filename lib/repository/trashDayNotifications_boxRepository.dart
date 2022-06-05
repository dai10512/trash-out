import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/typeAdapter/trashDayNotification.dart';

TrashDayNotificationsBoxRepository trashDayNotificationsBoxRepository = TrashDayNotificationsBoxRepository();

class TrashDayNotificationsBoxRepository {
  Box<dynamic> box = Hive.box<TrashDayNotification>('Notifications');

  void isFirst() {
    if (box.isEmpty) {
      addDefaultTrashDayNotifications();
    }
  }

  void addDefaultTrashDayNotifications() {
    final todayNotification = TrashDayNotification(
      whichDay: 0,
      time: const TimeOfDay(hour: 8, minute: 00),
      doNotify: false,
    );
    final tomorrowNotification = TrashDayNotification(
      whichDay: 1,
      time: const TimeOfDay(hour: 21, minute: 00),
      doNotify: false,
    );
    box.add(todayNotification);
    box.add(tomorrowNotification).then((value) => print('added default TrashDayNotification'));
  }

  TrashDayNotification getTrashDayNotification(int index) {
    final trashDayNotification = box.getAt(index);
    return trashDayNotification;
  }

  List<TrashDayNotification> getTrashDayNotifications() {
    List<TrashDayNotification> trashDayNotifications = box.values.toList().cast<TrashDayNotification>();
    return trashDayNotifications;
  }

  void writeTime(int index, TimeOfDay time) {
    print(time);
    final TrashDayNotification trashDayNotification = box.getAt(index);
    box.putAt(index, trashDayNotification.copyWith(time: time)).then((value) => print('write time'));
    print(trashDayNotification.time);
  }

  void writeDoNotify(int index, bool doNotify) {
    final TrashDayNotification trashDayNotification = box.getAt(index);
    box
        .putAt(
            index,
            trashDayNotification.copyWith(
              doNotify: doNotify,
            ))
        .then((value) => print('write doNotify'))
        .then((value) => print(trashDayNotification.doNotify));
  }
}
