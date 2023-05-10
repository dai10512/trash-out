// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'trashOfDayNotification_model.dart';
import '../repository/notificationSettings_boxRepository.dart';
import '../repository/trashList_boxRepository.dart';
import '../repository/trashOfDay_boxRepository.dart';
import '../typeAdapter/trashOfDay.dart';
import '../typeAdapter/trash.dart';
import '../typeAdapter/notificationSetting.dart';

import '../util/util.dart';

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
    // await AwesomeNotifications().cancelAllSchedules().then(
    //       (value) => print('init trashOfDayNotifications'),
    //       onError: (e) => print("$e}"),
    //     );
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
          int scheduleNumber = int.parse(weeksOfMonth[l].toString() + weekdays[s].toString());
          if (trashOfDayMap.containsKey(scheduleNumber)) {
            trashOfDayMap[scheduleNumber] = trashOfDayMap[scheduleNumber] + '\n' + trashType;
          } else {
            trashOfDayMap[scheduleNumber] = trashType;
          }
        }
      }
    }
    trashOfDayMap.forEach(
      (scheduleNumber, trashType) async {
        int weekOfMonth = int.parse(scheduleNumber.toString()[0]);
        int weekday = int.parse(scheduleNumber.toString()[1]);
        TrashOfDay tempTrashOfDay = TrashOfDay(totalTrashType: trashType, weekday: weekday, weekOfMonth: weekOfMonth);
        await trashOfDayBoxRepository.addTrashOfDay(tempTrashOfDay);
      },
    );
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
          TrashOfDay trashOfDay = trashOfDayList[s];
          String totalTrashType = trashOfDay.totalTrashType;
          int weekOfMonth = trashOfDay.weekOfMonth;
          int weekday = trashOfDay.weekday;
          totalTrashType = totalTrashType.replaceAll('\n', '、');
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
