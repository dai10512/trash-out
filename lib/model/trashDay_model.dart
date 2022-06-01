import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/view/trashDayDetail_view.dart';
import 'package:trash_out/view/trashDayList_view.dart';

final trashDayModelProvider = ChangeNotifierProvider<TrashDayModel>(
  (ref) => TrashDayModel(),
);

class TrashDayModel extends ChangeNotifier {
  String id = uuid.v4();
  String trashType = '';
  Map<int, bool> daysOfTheWeek = {1: false, 2: false, 3: false, 4: false, 5: false};
  Map<int, bool> ordinalNumbers = {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false};

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
