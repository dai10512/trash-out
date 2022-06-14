import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/modelAndController/trashOfDayNotification_controller.dart';
import 'package:trash_out/repository/notificationSettings_boxRepository.dart';

final notificationSettingModelProvider = ChangeNotifierProvider.family<NotificationSettingModel, dynamic>((ref, index) => NotificationSettingModel(index));

class NotificationSettingModel extends ChangeNotifier {
  int whichDay = 0;
  TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);
  bool doNotify = false;

  NotificationSettingModel(int index) {
    getTrashNotification(index);
  }

  void getTrashNotification(int index) {
    final loadedData = notificationSettingsBoxRepository.getNotificationSetting(index);
    whichDay = loadedData.whichDay;
    time = loadedData.time;
    doNotify = loadedData.doNotify;
    notifyListeners();
  }

  Future<void> writeTime(BuildContext context, int index, TimeOfDay initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      time = picked;
      await notificationSettingsBoxRepository.writeTime(index, time);
      await trashNotificationController.setNotifications();
    }
    notifyListeners();
  }

  Future<void> writeDoNotify(int index) async {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
    doNotify = !doNotify;
    await notificationSettingsBoxRepository.writeDoNotify(index, doNotify);
    await trashNotificationController.setNotifications();
    notifyListeners();
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
}
