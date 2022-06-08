import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/modelAndController/trashNotification_controller.dart';
import 'package:trash_out/repository/trashDays_boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/util/util.dart';

final AutoDisposeChangeNotifierProviderFamily<TrashDayModel, dynamic> trashDayModelProvider =
    ChangeNotifierProvider.family.autoDispose<TrashDayModel, dynamic>((ref, hiveKey) => TrashDayModel(hiveKey));

class TrashDayModel extends ChangeNotifier {
  String id = uuid.v4();
  String trashType = '';
  Map<int, bool> daysOfWeek = {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false};
  Map<int, bool> weeksOfMonth = {1: true, 2: true, 3: true, 4: true, 5: true};

  TrashDayModel(dynamic hiveKey) {
    getData(hiveKey);
  }

  void getData(dynamic hiveKey) {
    final TrashDay? loadedData = trashDaysBoxRepository.getTrashDay(hiveKey);
    if (loadedData != null) {
      id = loadedData.id;
      trashType = loadedData.trashType;
      daysOfWeek = {...loadedData.daysOfWeek};
      weeksOfMonth = {...loadedData.weeksOfMonth};
    }
    print('got data');
  }

  Future<void> saveTrashDay(dynamic hiveKey, TrashDayModel trashDayModel) async {
    final tempTrashDay = TrashDay(
      id: trashDayModel.id,
      trashType: trashDayModel.trashType,
      daysOfWeek: trashDayModel.daysOfWeek,
      weeksOfMonth: trashDayModel.weeksOfMonth,
    );
    if (hiveKey == null) {
      await addTrashDay(tempTrashDay);
    } else {
      await updateTrashDay(hiveKey, tempTrashDay);
    }
    await trashNotificationController.setNotifications();
  }

  Future<void> addTrashDay(TrashDay tempTrashDay) async {
    trashDaysBoxRepository.addTrashDay(tempTrashDay);
  }

  Future<void> updateTrashDay(dynamic hiveKey, TrashDay tempTrashDay) async {
    trashDaysBoxRepository.updateTrashType(hiveKey, tempTrashDay);
  }

  Future<void> deleteTrashDay(dynamic hiveKey) async {
    await trashDaysBoxRepository.deleteTrashDay(hiveKey).then(
          (value) => trashNotificationController.setNotifications(),
        );
  }

  void writeTrashType(String text) {
    trashType = text;
  }

  void writeDaysOfWeek(int index) {
    daysOfWeek[index] = !daysOfWeek[index]!;
    notifyListeners();
  }

  void writeWeeksOfMonth(int index) {
    weeksOfMonth[index] = !weeksOfMonth[index]!;
    notifyListeners();
  }
}
