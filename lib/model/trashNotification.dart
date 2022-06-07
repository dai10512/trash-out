import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trash_out/repository/notificationSettings_boxRepository.dart';
import 'package:trash_out/repository/trashDays_boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/typeAdapter/notificationSetting.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:trash_out/util/util.dart';

final TrashNotification trashNotification = TrashNotification();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// class TrashDayNotificationController{
class TrashNotification {

  List<TrashDay> trashDays = [];
  List<NotificationSetting> notificationSettings = [];
  String notificationTitle = 'ゴミ出しの案内';
  String notificationMessage = '';

  //初めての起動時に呼び出し、permissionの設定を促す。インスタンスの有無で判断される
  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // アプリ起動時に呼び出す＋更新の都度呼び出す
  void setNotifications() {
    // cancelNotifications();
    getData();
    judgeSetNotification();
    // everyMinuteNotification();
  }

  void getData() {
    trashDays = trashDaysBoxRepository.getTrashDays();
    notificationSettings = notificationSettingsBoxRepository.getNotificationSettings();
    print('got Data');
    print(trashNotification.trashDays);
    print(trashNotification.notificationSettings);
  }

  Future<void> cancelAllNotifications() async {
    // await flutterLocalNotificationsPlugin.cancelAll().then((value) => print('cancel notifications'));
    await AwesomeNotifications().cancelAllSchedules();
    print('cancelled all notification');
  }

  void judgeSetNotification() {
    // getData();
    print('start judge');

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
          final List<int> daysOfWeek = mapToList(trashDay.daysOfWeek);
          final List<int> weeksOfMonth = mapToList(trashDay.weeksOfMonth);

          // 曜日があっているか判断
          for (var i = 0; i < daysOfWeek.length; i++) {
            // 週が一致しているか判断
            for (var l = 0; l < weeksOfMonth.length; l++) {
              if (whichDay == 0) {
                notificationMessage = '本日のゴミは、$trashTypeです';
              } else {
                notificationMessage = '明日のゴミは、$trashTypeです';
              }
              createNotification(notificationTitle, notificationMessage, weeksOfMonth[l], daysOfWeek[i], time);
            }
          }
        }
      }
    }
  }

  void createNotification(title, body, week, weekday, time) {
    AwesomeNotifications()
        .createNotification(
          content: NotificationContent(
            id: int.parse(week.toString() + weekday.toString() + time.hour.toString() + time.minute.toString()),
            channelKey: 'trashOut',
            title: title,
            body: body,
          ),
          schedule: NotificationCalendar(
            weekOfMonth: week,
            weekday: weekday,
            hour: time.hour,
            minute: time.minute,
            repeats: true,
          ),
        )
        .then((value) => print('notification scheduled'))
        .then((value) => print('title:$title / body:$body | 週${week} / 曜日${weekday} / 時間${time.hour}:${time.minute}'));
  }
}

class Notification {
  String title;
  String body;
  int weekOfMonth;
  int dayOfWeek;
  TimeOfDay time;

  Notification(this.title, this.body, this.weekOfMonth, this.dayOfWeek, this.time) {
    createNotification(this.title, this.body, this.weekOfMonth, this.dayOfWeek, this.time);
  }

  void createNotification(title, body, week, weekday, time) {
    AwesomeNotifications()
        .createNotification(
          content: NotificationContent(
            id: int.parse(week.toString() + weekday.toString() + time.hour.toString() + time.minute.toString()),
            channelKey: 'trashOut',
            title: title,
            body: body,
          ),
          schedule: NotificationCalendar(
            weekOfMonth: week,
            weekday: weekday,
            hour: time.hour,
            minute: time.minute,
            repeats: true,
          ),
        )
        .then((value) => print('notification scheduled'))
        .then((value) => print('title:$title / body:$body | 週${week} / 曜日${weekday} / 時間${time.hour}:${time.minute}'));
  }
}
