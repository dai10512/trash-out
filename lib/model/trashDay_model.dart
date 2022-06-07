import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/repository/trashDays_boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/util/util.dart';

final AutoDisposeChangeNotifierProviderFamily<TrashDayModel, dynamic> trashDayModelProvider = ChangeNotifierProvider.family.autoDispose<TrashDayModel, dynamic>((ref, hiveKey) => TrashDayModel(hiveKey));

class TrashDayModel extends ChangeNotifier {
  String id = uuid.v4();
  String trashType = '';
  Map<int, bool> daysOfWeek = {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false};
  Map<int, bool> weeksOfMonth = {1: true, 2: true, 3: true, 4: true, 5: true};

  TrashDayModel(dynamic hiveKey) {
    loadData(hiveKey);
  }

  void loadData(dynamic hiveKey) {
    final TrashDay? loadedData = trashDaysBoxRepository.getTrashDay(hiveKey);
    if (loadedData != null) {
      id = loadedData.id;
      trashType = loadedData.trashType;
      daysOfWeek = {...loadedData.daysOfWeek};
      weeksOfMonth = {...loadedData.weeksOfMonth};
    }
    print('loaded');
  }

  void saveTrashDay(dynamic hiveKey, TrashDayModel trashDayModel) {
    final tempTrashDay = TrashDay(
      id: trashDayModel.id,
      trashType: trashDayModel.trashType,
      daysOfWeek: trashDayModel.daysOfWeek,
      weeksOfMonth: trashDayModel.weeksOfMonth,
    );
    if (hiveKey == null) {
      addTrashDay(tempTrashDay);
    } else {
      updateTrashDay(hiveKey, tempTrashDay);
    }
  }

  void addTrashDay(tempTrashDay) {
    trashDaysBoxRepository.addTrashDay(tempTrashDay);
  }

  void updateTrashDay(hiveKey, tempTrashDay) {
    trashDaysBoxRepository.updateTrashType(hiveKey, tempTrashDay);
  }

  void deleteTrashDay(dynamic hiveKey) {
    trashDaysBoxRepository.deleteTrashDay(hiveKey);
  }

  void writeTrashType(String text) {
    trashType = text;
  }

  void writedaysOfWeek(int index) {
    daysOfWeek[index] = !daysOfWeek[index]!;
    notifyListeners();
  }

  void writeweeksOfMonth(int index) {
    weeksOfMonth[index] = !weeksOfMonth[index]!;
    notifyListeners();
  }
}
