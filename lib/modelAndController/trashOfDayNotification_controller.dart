import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:trash_out/modelAndController/trashOfDayNotification_model.dart';
import 'package:trash_out/repository/notificationSettings_boxRepository.dart';
import 'package:trash_out/repository/trashList_boxRepository.dart';
import 'package:trash_out/repository/trashOfDay_boxRepository.dart';
import 'package:trash_out/typeAdapter/TrashOfDay.dart';
import 'package:trash_out/typeAdapter/trash.dart';
import 'package:trash_out/typeAdapter/notificationSetting.dart';

import 'package:trash_out/util/util.dart';

final TrashNotificationController trashNotificationController = TrashNotificationController();
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// class TrashNotificationController{
class TrashNotificationController {
  List<Trash> trashList = [];
  List<NotificationSetting> notificationSettings = [];
  // Map<int, String> trashDayMap = {};
  // Map trashOfDayMap = {};

  // アプリ起動時に呼び出す＋更新の都度呼び出す
  Future<void> setNotifications() async {
    await initTrashOfDayNotifications();
    await initTrashOfDayList();
    await uploadTrashOfDay();
    await setTrashOfDayNotification();
  }

  Future<void> initTrashOfDayNotifications() async {
    await AwesomeNotifications().cancelAllSchedules().then(
          (value) => print('init trashOfDayNotifications'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> initTrashOfDayList() async {
    await trashOfDayBoxRepository.clearTrashOfDay().then(
          (value) => print('init TrashDayList'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> uploadTrashOfDay() async {

    Map trashOfDayMap = {};
    trashList = trashListBoxRepository.getTrashList();

    for (var p = 0; p < trashList.length; p++) {
      final Trash trash = trashList[p];
      final String trashType = trash.trashType;
      final List<int> weekdays = mapToList(trash.weekdays);
      final List<int> weeksOfMonth = mapToList(trash.weeksOfMonth);
      for (var l = 0; l < weeksOfMonth.length; l++) {
        for (var s = 0; s < weekdays.length; s++) {
          int scheduleNumber = int.parse(weeksOfMonth[l].toString() + weekdays[s].toString()) ;
          if (trashOfDayMap.containsKey(scheduleNumber)) {
            trashOfDayMap[scheduleNumber] = trashOfDayMap[scheduleNumber] + ',' + trashType;
          } else {
            trashOfDayMap[scheduleNumber] = trashType;
          }
        }
      }
    }
    trashOfDayMap.forEach((scheduleNumber, trashType)async {
      int weekOfMonth = int.parse(scheduleNumber.toString()[0]);
      int weekday = int.parse(scheduleNumber.toString()[1]);
      TrashOfDay tempTrashOfDay = TrashOfDay(totalTrashType: trashType, weekday: weekday, weekOfMonth: weekOfMonth);
      await trashOfDayBoxRepository.addTrashOfDay(tempTrashOfDay);
    });
        print('upload setTrashOfDay');

  }

  Future<void> setTrashOfDayNotification() async {
    print('start set TrashOfDay Notification');
    notificationSettings = notificationSettingsBoxRepository.getNotificationSettings();

    // 通知スケジュールの数だけ繰り返し..2
    for (var s = 0; s < notificationSettings.length; s++) {
      final NotificationSetting notificationSetting = notificationSettings[s];
      final TimeOfDay time = notificationSetting.time;
      final bool doNotify = notificationSetting.doNotify;
      final int whichDay = notificationSetting.whichDay;

      // 通知がオンになっているか確認してからデータを取得
      if (doNotify) {
        String notificationMessage = '';
        List<TrashOfDay> trashOfDayList = trashOfDayBoxRepository.getTrashOfDayList();

        // アイテムの数だけ繰り返し
        for (var s = 0; s < trashOfDayList.length; s++) {
          final TrashOfDay trashOfDay = trashOfDayList[s];
          final int weekOfMonth = trashOfDay.weekOfMonth;
          final int weekday = trashOfDay.weekday;
          final String totalTrashType = trashOfDay.totalTrashType;
          if (whichDay == 0) {
            notificationMessage = '本日の収集ゴミは、$totalTrashTypeです';
          } else {
            notificationMessage = '明日の収集ゴミは、$totalTrashTypeです';
          }
          TrashNotificationModel(notificationMessage, weekOfMonth, weekday, time);
        }
      }
    }
  }
}
