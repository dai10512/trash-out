import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/view/trashDayList_view.dart';

final trashDayModelProvider = ChangeNotifierProvider<TrashDayModel>(
  (ref) => TrashDayModel(),
);

class TrashDayModel extends ChangeNotifier {
  String id = '';
  String trashType = '';
  // List<int> daysOfTheWeek = [];
  // List<int> ordinalNumbers = [];
  Map<int, bool> daysOfTheWeek = {};
  Map<int, bool> ordinalNumbers = {};

  void loadData(trashDay) {
    if (trashDay != null) {
      id = trashDay.id;
      trashType = trashDay.trashType;
      daysOfTheWeek = trashDay.daysOfTheWeek;
      ordinalNumbers = trashDay.ordinalNumbers;
    }
  }

  void updateTrashType(value) {
    trashType = value;
  }

  void updateDaysOfTheWeek(int index) {
    daysOfTheWeek[index] = !daysOfTheWeek[index]!;
  }

  void updateOrdinalNumbers(int index) {
    ordinalNumbers[index] = !ordinalNumbers[index]!;
  }
}
