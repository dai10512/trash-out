import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trash_out/modelAndController/trashNotification_model.dart';
import 'package:trash_out/repository/notificationSettings_boxRepository.dart';
import 'package:trash_out/repository/trashDays_boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/typeAdapter/notificationSetting.dart';

import 'package:trash_out/util/util.dart';

final TrashNotificationController trashNotificationController = TrashNotificationController();
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// class TrashDayNotificationController{
class TrashNotificationController {
  List<TrashDay> trashDays = [];
  List<NotificationSetting> notificationSettings = [];

  //初めての起動時に呼び出し、permissionの設定を促す。インスタンスの有無で判断される
  // Future<void> requestPermissions() async {
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       )
  //       .then(
  //         (value) => print('requested Permission'),
  //         onError: (e) => print("$e}"),
  //       );
  // }

  // アプリ起動時に呼び出す＋更新の都度呼び出す
  Future<void> setNotifications() async {
    await cancelAllNotifications().then(
      (value) => getData().then(
        (value) => judgeSetNotification(),
        onError: (e) => print("$e}"),
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAllSchedules().then(
          (value) => print('cancelled all notification'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> getData() async {
    trashDays = trashDaysBoxRepository.getTrashDays();
    notificationSettings = notificationSettingsBoxRepository.getNotificationSettings();
    print('got Data');
  }

  Future<void> judgeSetNotification() async {
    print('set notifications');
    String notificationMessage = '';

    // 通知スケジュールの数だけ繰り返し..2
    for (var s = 0; s < notificationSettings.length; s++) {
      final NotificationSetting notificationSetting = notificationSettings[s];
      final TimeOfDay time = notificationSetting.time;
      final bool doNotify = notificationSetting.doNotify;
      final int whichDay = notificationSetting.whichDay;

      // 通知がオンになっているか
      if (doNotify) {
        // アイテムの数だけ繰り返し
        for (var p = 0; p < trashDays.length; p++) {
          final TrashDay trashDay = trashDays[p];
          final String trashType = trashDay.trashType;
          final List<int> weekdays = mapToList(trashDay.daysOfWeek);
          final List<int> weeksOfMonth = mapToList(trashDay.weeksOfMonth);

          // 曜日があっているか判断
          for (var i = 0; i < weekdays.length; i++) {
            // 週が一致しているか判断
            for (var l = 0; l < weeksOfMonth.length; l++) {
              if (whichDay == 0) {
                notificationMessage = '本日のゴミは、$trashTypeです';
              } else {
                notificationMessage = '明日のゴミは、$trashTypeです';
              }
              TrashNotificationModel(notificationMessage, weeksOfMonth[l], weekdays[i], time);
            }
          }
        }
      }
    }
    print('Set Notifications');
  }

  // Future<void> judgeSetNotification2() async {
  //   print('set notifications');

  //   // 通知スケジュールの数だけ繰り返し..2
  //   for (var s = 0; s < notificationSettings.length; s++) {
  //     final NotificationSetting notificationSetting = notificationSettings[s];
  //     final TimeOfDay time = notificationSetting.time;
  //     final bool doNotify = notificationSetting.doNotify;
  //     final int whichDay = notificationSetting.whichDay;

  //     // 通知がオンになっているか
  //     if (doNotify) {
  //       // アイテムの数だけ繰り返し
  //       for (var p = 0; p < trashDays.length; p++) {
  //         final TrashDay trashDay = trashDays[p];
  //         final String trashType = trashDay.trashType;
  //         final List<int> weekdays = mapToList(trashDay.daysOfWeek);
  //         final List<int> weeksOfMonth = mapToList(trashDay.weeksOfMonth);
  //         Map<Map<int, int>, String> trashTypeMap = {};

  //         // 曜日があっているか判断
  //         for (var i = 0; i < weekdays.length; i++) {
  //           // 週が一致しているか判断
  //           for (var l = 0; l < weeksOfMonth.length; l++) {
  //             if (whichDay == 0) {
  //             } else {
  //             }
  //             // TrashNotificationModel(notificationMessage, weeksOfMonth[l], weekdays[i], time);
  //           }
  //         }
  //       }
  //     }
  //   }
  //   print('Set Notifications');
  // }
}
