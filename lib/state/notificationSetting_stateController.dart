import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final sendNotificationOnTheDayProvider = StateProvider((ref) => false);
final sendNotificationTheDayBeforeProvider = StateProvider((ref) => false);

final timeOnTheDayProvider = StateProvider((ref) => const TimeOfDay(hour: 8, minute: 00));
final timeTheDayBeforeProvider = StateProvider((ref) => const TimeOfDay(hour: 21, minute: 00));

Future<void> selectTime(context, minusDay, timeState, sendNotification) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: timeState.state,
    initialEntryMode: TimePickerEntryMode.input,
  );
  if (picked != null) {
    timeState.state = picked;
    if (sendNotification.state) {
      scheduleDailyTimeNotification(minusDay, timeState.state.hour, timeState.state.minute);
    }
  }
}

String formatTime(TimeOfDay tod) {
  final String hourString = tod.hour.toString();
  late final String minuteString;

  if (0 <= tod.minute && tod.minute < 10) {
    minuteString = '0${tod.minute}';
  } else {
    minuteString = tod.minute.toString();
  }
  return '$hourString:$minuteString';
}

Future<void> scheduleDailyTimeNotification(
  minusDay,
  hour,
  minute,
) async {
  final String description;
  final List<String> trashList = [];
  if (minusDay == 0) {
    description = '今日のゴミは$trashListです';
  } else {
    description = '明日のゴミは$trashListです';
  }
  await FlutterLocalNotificationsPlugin()
      .zonedSchedule(
          minusDay,
          'ゴミ出しの案内',
          description,
          _nextInstanceOfDailyTime(minusDay, hour, minute),
          const NotificationDetails(
            android: AndroidNotificationDetails('daily notification channel id', 'daily notification channel name',
                channelDescription: 'daily notification description'),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time)
      .then((value) {
    print('id:$minusDay');
    print('scheduled');
  });
}

tz.TZDateTime _nextInstanceOfDailyTime(minusDay, hour, minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  print(now.day.runtimeType);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> singleNotify(title, description) {
  return FlutterLocalNotificationsPlugin()
      .initialize(
        const InitializationSettings(
          iOS: IOSInitializationSettings(),
        ),
      )
      .then(
        (_) => FlutterLocalNotificationsPlugin().show(
          0,
          title,
          description,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
            ),
          ),
        ),
      );
}

String formatMinute(int minute) {
  String minuteString = minute.toString();

  if (0 <= minute && minute < 10) {
    minuteString = '0$minute';
  }
  return minuteString;
}

Future<void> cancelNotification(minusDay) async {
  await FlutterLocalNotificationsPlugin().cancel(minusDay).then((value) {
    print('id:$minusDay');
    print('canceled');
  });
}
