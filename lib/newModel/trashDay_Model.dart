import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/repository/boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:uuid/uuid.dart';

final trashDayModelProvider = ChangeNotifierProvider.family.autoDispose<TrashDayModel, dynamic>((ref, hiveKey) => TrashDayModel(hiveKey));

Uuid uuid = const Uuid();

class TrashDayModel extends ChangeNotifier {
  // String id = uuid.v4();
  String id = uuid.v4();
  String trashType = '';
  Map<int, bool> daysOfTheWeek = {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false};
  Map<int, bool> ordinalNumbers = {1: true, 2: true, 3: true, 4: true, 5: true};

  TrashDayModel(dynamic hiveKey) {
    loadData(hiveKey);
  }

  void loadData(dynamic hiveKey) {
    final TrashDay? loadedData = boxRepository.getTrashDay(hiveKey);
    if (loadedData != null) {
      id = loadedData.id;
      trashType = loadedData.trashType;
      daysOfTheWeek = {...loadedData.daysOfTheWeek};
      ordinalNumbers = {...loadedData.ordinalNumbers};
    }
    print('loaded');
  }

  void saveTrashDay(dynamic hiveKey, TrashDayModel trashDayModel) {
    final tempTrashDay = TrashDay(
      id: trashDayModel.id,
      trashType: trashDayModel.trashType,
      daysOfTheWeek: trashDayModel.daysOfTheWeek,
      ordinalNumbers: trashDayModel.ordinalNumbers,
    );
    if (hiveKey == null) {
      boxRepository.addTrashDay(tempTrashDay);
    } else {
      boxRepository.updateTrashType(hiveKey, tempTrashDay);
    }
  }

  void writeTrashType(String text) {
    trashType = text;
  }

  void writeDaysOfTheWeek(int index) {
    daysOfTheWeek[index] = !daysOfTheWeek[index]!;
    notifyListeners();
  }

  void writeOrdinalNumbers(int index) {
    ordinalNumbers[index] = !ordinalNumbers[index]!;
    notifyListeners();
  }
}
