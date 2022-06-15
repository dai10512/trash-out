import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/modelAndController/trashOfDayNotification_controller.dart';
import 'package:trash_out/modelAndController/trashOfDay_model.dart';
import 'package:trash_out/repository/trashList_boxRepository.dart';
import 'package:trash_out/typeAdapter/trash.dart';

final AutoDisposeChangeNotifierProviderFamily<TrashModel, dynamic> trashModelProvider =
    ChangeNotifierProvider.family.autoDispose<TrashModel, dynamic>((ref, hiveKey) => TrashModel(hiveKey));

class TrashModel extends ChangeNotifier {
  String trashType = '';
  Map<int, bool> daysOfWeek = {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false};
  Map<int, bool> weeksOfMonth = {1: true, 2: true, 3: true, 4: true, 5: true};

  TrashModel(dynamic hiveKey) {
    getData(hiveKey);
  }

  void getData(dynamic hiveKey) {
    final Trash? loadedData = trashListBoxRepository.getTrash(hiveKey);
    if (loadedData != null) {
      trashType = loadedData.trashType;
      daysOfWeek = {...loadedData.weekdays};
      weeksOfMonth = {...loadedData.weeksOfMonth};
    }
  }

  Future<void> saveTrash(dynamic hiveKey, TrashModel trashModel) async {
    final tempTrash = Trash(
      trashType: trashModel.trashType,
      weekdays: trashModel.daysOfWeek,
      weeksOfMonth: trashModel.weeksOfMonth,
    );
    if (hiveKey == null) {
      await addTrash(tempTrash);
    } else {
      await updateTrash(hiveKey, tempTrash);
    }
    await trashNotificationController.setNotifications();
  }

  Future<void> addTrash(Trash tempTrash) async {
    trashListBoxRepository.addTrash(tempTrash);
  }

  Future<void> updateTrash(dynamic hiveKey, Trash tempTrash) async {
    trashListBoxRepository.updateTrashType(hiveKey, tempTrash);
  }

  Future<void> deleteTrash(dynamic hiveKey) async {
    await trashListBoxRepository.deleteTrash(hiveKey).then(
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
