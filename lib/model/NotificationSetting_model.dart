import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/repository/notificationSettings_boxRepository.dart';

// final trashDayNotificationModelProvider = ChangeNotifierProvider.family<TrashDayNotificationModel, dynamic>((ref, index) => TrashDayNotificationModel(index));
final notificationSettingModelProvider = ChangeNotifierProvider.family<NotificationSettingModel, dynamic>((ref, index) => NotificationSettingModel(index));

// TrashDayNotificationModel trashDayNotificationModel = TrashDayNotificationModel(index);



class NotificationSettingModel extends ChangeNotifier {

// class TrashDayNotificationModel extends ChangeNotifier {
// class TrashDayNotificationModel {
  int whichDay = 0;
  TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
  bool doNotify = false;

  NotificationSettingModel(index) {
    getTrashDayNotification(index);
  }

  void getTrashDayNotification(int index) {
    final loadedData = notificationSettingsBoxRepository.getNotificationSetting(index);
    whichDay = loadedData.whichDay;
    time = loadedData.time;
    doNotify = loadedData.doNotify;
    notifyListeners();
  }

  Future<void> writeTime(BuildContext context, int index, TimeOfDay initialTime) async {
    print('taped time');
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      time = picked;
      notificationSettingsBoxRepository.writeTime(index, time);
    }
    notifyListeners();
  }

  void writeDoNotify(int index) {
    doNotify = !doNotify;
    notificationSettingsBoxRepository.writeDoNotify(index, doNotify);
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



