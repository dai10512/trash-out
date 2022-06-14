import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class TrashNotificationModel {
  String title = 'TrashOutからの通知';
  String body;
  int weekOfMonth;
  int weekday;
  TimeOfDay time;

  TrashNotificationModel(this.body, this.weekOfMonth, this.weekday, this.time) {
    createNotification();
    print('created Notification');
  }

  Future<void> createNotification() async{
    AwesomeNotifications()
        .createNotification(
          content: NotificationContent(
            id: int.parse(weekOfMonth.toString() + weekday.toString() + time.hour.toString() + time.minute.toString()),
            channelKey: 'trashOut',
            title: title,
            body: body,
          ),
          schedule: NotificationCalendar(
            weekOfMonth: weekOfMonth,
            weekday: weekday,
            hour: time.hour,
            minute: time.minute,
            repeats: true,
          ),
        )
        .then((value) => print('title:$title / body:$body | 週$weekOfMonth / 曜日$weekday / 時間${time.hour}:${time.minute}'));
  }
}
