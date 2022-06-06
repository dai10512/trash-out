import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trash_out/repository/trashDayNotifications_boxRepository.dart';
import 'package:trash_out/repository/trashDaysBox_repository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/typeAdapter/trashDayNotification.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:trash_out/util/util.dart';

final LocalNotification localNotification = LocalNotification();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class LocalNotification {
  DateTime currentTime = DateTime.now();
  List<TrashDay> trashDays = [];
  List<TrashDayNotification> trashDayNotifications = [];
  String notificationTitle = 'ゴミ出しの案内';
  String notificationMessage = '';
  // int whichDay = 0;

  // アプリ起動時に呼び出す＋更新の都度呼び出す
  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void setNotifications() {
    // cancelNotifications();
    getData();
    // judgeSetNotification();
    everyMinuteNotification();
  }

  // createNotifyMessage(trashDays, trashDayNotifications);

  void getData() {
    trashDays = trashDaysBoxRepository.getTrashDays();
    trashDayNotifications = trashDayNotificationsBoxRepository.getTrashDayNotifications();
    print('got Data');
    print(localNotification.trashDays);
    print(localNotification.trashDayNotifications);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll().then((value) => print('cancel notifications'));
  }

  Future<void> everyMinuteNotification() async {
    String answer = (currentTime.minute / 2 == 0) ? '偶数' : '奇数';
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      answer,
      // 'repeating channel id',
      'repeating channel name',
      channelDescription: 'repeating description',
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .periodicallyShow(
          0,
          answer,
          'repeating body',
          RepeatInterval.everyMinute,
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
        )
        .then((value) => print('everyMinute'));
  }

  Future<void> scheduleNotification(int whichDay, TimeOfDay time) async {
    final int hour = time.hour;
    final int minute = time.minute;
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    await FlutterLocalNotificationsPlugin()
        .zonedSchedule(
            whichDay,
            notificationTitle,
            notificationMessage,
            tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute + 1, 0),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'daily notification channel id',
                'daily notification channel name',
                channelDescription: 'daily notification description',
              ),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time)
        .then((value) {
      // print('id:$minusDay');
      print('scheduled');
      print(whichDay);
      print(hour);
    });
  }

  void judgeSetNotification() {
    print('start judge');

    // 通知スケジュールの数だけ繰り返し..2
    for (var s = 0; s < trashDayNotifications.length; s++) {
      final TrashDayNotification trashDayNotification = trashDayNotifications[s];
      final TimeOfDay time = trashDayNotification.time;
      final bool doNotify = trashDayNotification.doNotify;
      final int whichDay = trashDayNotification.whichDay;

      // 通知がオンになっているか
      if (doNotify) {
        // アイテムの数だけ繰り返し
        for (var p = 0; p < trashDays.length; p++) {
          final TrashDay trashDay = trashDays[p];
          final String trashType = trashDay.trashType;
          final List<int> weekdays = util.mapToList(trashDay.weekdays);
          final List<int> weeks = util.mapToList(trashDay.weeks);

          // 曜日があっているか判断
          for (var i = 0; i < weekdays.length; i++) {
            if (currentTime.weekday == weekdays[i]) {
              // 週が一致しているか判断
              for (var l = 0; l < weeks.length; l++) {
                if ((currentTime.day / 7) + 1 == weeks[p]) {
                  notificationMessage += '$trashType、';
                }
              }
            }
          }
        }
      }
      // wordの末尾をカット//
      scheduleNotification(whichDay, time);
    }
  }
}
