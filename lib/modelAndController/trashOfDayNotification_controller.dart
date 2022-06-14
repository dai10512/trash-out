import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trash_out/modelAndController/TrashOfDayNotification_model.dart';
import 'package:trash_out/modelAndController/trashOfDay_model.dart';
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
  Map trashOfDayMap = {};


  // アプリ起動時に呼び出す＋更新の都度呼び出す
  Future<void> setNotifications() async {
    await cancelAllTrashNotifications().then(
      (value) => getData().then(
        // (value) => judgeSetNotification(),
        // (value) => setTrashDayMap().then(
        (value) => setTrashOfDay().then(
          (value) => setTrashNotification(),
          onError: (e) => print("$e}"),
        ),
      ),
    );
  }

  Future<void> cancelAllTrashNotifications() async {
    await AwesomeNotifications().cancelAllSchedules().then(
          (value) => print('cancelled all notification'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> getData() async {
    trashList = trashListBoxRepository.getTrashList();
    notificationSettings = notificationSettingsBoxRepository.getNotificationSettings();
    // trashOfDayList = trashOfDayBoxRepository.getTrashOfDayList();
    print('got Data');
  }

  Future<void> setTrashOfDay() async {
    // Map trashOfDayMap = {};
    for (var p = 0; p < trashList.length; p++) {
      final Trash trash = trashList[p];
      final String trashType = trash.trashType;
      final List<int> weekdays = mapToList(trash.weekdays);
      final List<int> weeksOfMonth = mapToList(trash.weeksOfMonth);
      for (var l = 0; l < weeksOfMonth.length; l++) {
        for (var s = 0; s < weekdays.length; s++) {
          int scheduleNumber = int.parse(weekdays[s].toString() + weeksOfMonth[l].toString());
          if(trashOfDayMap.containsKey(scheduleNumber)){
            trashOfDayMap[scheduleNumber] = trashOfDayMap[scheduleNumber] + ',' + trashType;
          }else{
            trashOfDayMap[scheduleNumber] = trashType;
          }
        }
      }
    }
    trashOfDayMap.forEach((scheduleNumber, trashType){
      int weekOfMonth = scheduleNumber[0];
      int weekday = scheduleNumber[1];
      TrashOfDay tempTrashOfDay = TrashOfDay(totalTrashType:trashType, weekday: weekday, weekOfMonth: weekOfMonth);
      trashOfDayBoxRepository.addTrashOfDay(tempTrashOfDay);
    }
    );
    // print('set TrashDayMap');
  }

  // List<String> setTotalTrashType(int whichDay) {
  //   List<String> totalTrashTypeList = ['収集はありません', '収集はありません'];

  //   DateTime now = DateTime.now();
  //   DateTime targetDay = DateTime(now.year, now.month, now.day + whichDay);

  //   Map<int, String> trashDayMap = trashNotificationController.trashDayMap;

  //   trashDayMap.forEach(
  //     (key, value) {
  //       final int weekOfMonth = int.parse(key.toString()[1]);
  //       final int weekday = int.parse(key.toString()[2]);
  //       final String totalTrashTypes = value;
  //       if ((targetDay.day / 7) + 1 == weekOfMonth && now.weekday == weekday) {
  //         totalTrashTypeList[whichDay] = totalTrashTypes;
  //       }
  //     },
  //   );
  //   return totalTrashTypeList;
  // }

  // Future<void> setTrashOfDayList() async {
  //   for (var p = 0; p < trashList.length; p++) {
  //     final Trash trash = trashList[p];
  //     final String trashType = trash.trashType;
  //     final List<int> weekdays = mapToList(trash.weekdays);
  //     final List<int> weeksOfMonth = mapToList(trash.weeksOfMonth);
  //     for (var l = 0; l < weeksOfMonth.length; l++) {
  //       for (var s = 0; s < weekdays.length; s++) {
  //         int scheduleNumber = int.parse(weekdays[s].toString() + weeksOfMonth[l].toString());
  //         if (trashDayMap.containsKey(scheduleNumber)) {
  //           trashDayMap[scheduleNumber] = '${trashDayMap[scheduleNumber]!}、$trashType';
  //         } else {
  //           trashDayMap[scheduleNumber] = trashType;
  //         }
  //         TrashOfDayModel tempTrashOfDay = TrashOfDayModel(totalTrashType: trashType, weekday: weekdays[s], weekOfMonth: weeksOfMonth[l]);
  //         trashOfDayBoxRepository.addTrashOfDay(tempTrashOfDay);
  //       }
  //     }
  //   }
  // }

  // Future<void> setTrashNotification() async {
  //   String notificationMessage = '';
  //   List trashOfDayList = trashOfDayBoxRepository.getTrashOfDayList();

  //   // 通知スケジュールの数だけ繰り返し..2
  //   for (var s = 0; s < notificationSettings.length; s++) {
  //     final NotificationSetting notificationSetting = notificationSettings[s];
  //     final TimeOfDay time = notificationSetting.time;
  //     final bool doNotify = notificationSetting.doNotify;
  //     final int whichDay = notificationSetting.whichDay;

  //     // 通知がオンになっているか
  //     if (doNotify) {
  //       // アイテムの数だけ繰り返し
  //   for (var s = 0; s < trashOfDayList.length; s++) {
  //     final TrashOfDay trashOfDay = trashOfDayList[s];

  //     trashOfDay.weekOfMonth
  //           final int weekOfMonth = int.parse(key.toString()[1]);
  //           final int weekday = int.parse(key.toString()[2]);
  //           final String trashTypes = value;
  //           if (whichDay == 0) {
  //             notificationMessage = '本日のゴミは、$trashTypesです';
  //           } else {
  //             notificationMessage = '明日のゴミは、$trashTypesです';
  //           }
  //           TrashNotificationModel(notificationMessage, weekOfMonth, weekday, time);
  //         },
  //       );
  //     }
  //   }
  //   print('Set Notifications');
  // }
}
