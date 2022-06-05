import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/repository/trashDaysBox_repository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:uuid/uuid.dart';

final trashDayModelProvider = ChangeNotifierProvider.family.autoDispose<TrashDayModel, dynamic>((ref, hiveKey) => TrashDayModel(hiveKey));

Uuid uuid = const Uuid();

class TrashDayModel extends ChangeNotifier {
  String id = uuid.v4();
  String trashType = '';
  Map<int, bool> weekdays = {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false};
  Map<int, bool> weeks = {1: true, 2: true, 3: true, 4: true, 5: true};

  TrashDayModel(dynamic hiveKey) {
    loadData(hiveKey);
  }

  void loadData(dynamic hiveKey) {
    final TrashDay? loadedData = trashDaysBoxRepository.getTrashDay(hiveKey);
    if (loadedData != null) {
      id = loadedData.id;
      trashType = loadedData.trashType;
      weekdays = {...loadedData.weekdays};
      weeks = {...loadedData.weeks};
    }
    print('loaded');
  }

  void saveTrashDay(dynamic hiveKey, TrashDayModel trashDayModel) {
    final tempTrashDay = TrashDay(
      id: trashDayModel.id,
      trashType: trashDayModel.trashType,
      weekdays: trashDayModel.weekdays,
      weeks: trashDayModel.weeks,
    );
    if (hiveKey == null) {
      trashDaysBoxRepository.addTrashDay(tempTrashDay);
    } else {
      trashDaysBoxRepository.updateTrashType(hiveKey, tempTrashDay);
    }
  }

  void writeTrashType(String text) {
    trashType = text;
  }

  void writeWeekdays(int index) {
    weekdays[index] = !weekdays[index]!;
    notifyListeners();
  }

  void writeWeeks(int index) {
    weeks[index] = !weeks[index]!;
    notifyListeners();
  }
}
