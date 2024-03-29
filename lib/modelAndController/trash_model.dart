import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/trash_info.dart';
import '../repository/trashList_boxRepository.dart';
import '../typeAdapter/trash.dart';
import 'trashOfDayNotification_controller.dart';

// class TrashNotifier extends Notifier<Trash> {
//   @override
//   build() => Trash(trashType: '', weekdays: {});
// }

@riverpod
List<TrashInfo?>? trashInfoList(ref) => null;

// class TrashInfoListNotifier extends Notifier<> {
//   @override
//    build() {
//     return ;
//   }
// }

final AutoDisposeChangeNotifierProviderFamily<TrashModel, dynamic>
    trashModelProvider =
    ChangeNotifierProvider.family.autoDispose<TrashModel, dynamic>(
  (ref, hiveKey) => TrashModel(hiveKey),
);

class TrashModel extends ChangeNotifier {
  String trashType = '';
  Map<int, bool> daysOfWeek = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false,
  };
  Map<int, bool> weeksOfMonth = {
    1: true,
    2: true,
    3: true,
    4: true,
    5: true,
  };

////////////////////////////
  TrashModel(dynamic hiveKey) {
    getData(hiveKey);
  }

  //データ取得
  void getData(dynamic hiveKey) {
    final Trash? loadedData = trashListBoxRepository.getTrash(hiveKey);
    if (loadedData != null) {
      trashType = loadedData.trashType;
      daysOfWeek = {...loadedData.weekdays};
      weeksOfMonth = {...loadedData.weeksOfMonth};
    }
  }

  //データ保存
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

  //データ追加
  Future<void> addTrash(Trash tempTrash) async {
    trashListBoxRepository.addTrash(tempTrash);
  }

  // データ修正
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
