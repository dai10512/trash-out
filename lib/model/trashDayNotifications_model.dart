import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/repository/trashDayNotifications_boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDayNotification.dart';

final trashDayNotificationsModelProvider = ChangeNotifierProvider<TrashDayNotificationsModel>((ref) => TrashDayNotificationsModel());

TrashDayNotificationsModel trashDayNotificationsModel = TrashDayNotificationsModel();

class TrashDayNotificationsModel extends ChangeNotifier {
  List<TrashDayNotification> trashDayNotifications = [];

  TrashDayNotificationsModel() {
    getTrashDayNotifications();
  }

  void getTrashDayNotifications() {
    trashDayNotifications = trashDayNotificationsBoxRepository.getTrashDayNotifications();
  }
}
