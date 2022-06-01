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
  List<int> daysOfTheWeek = [];
  List<int> ordinalNumbers = [];

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

  void updateDaysOfTheWeek(value) {
    daysOfTheWeek.add(value);
  }

  void updateOrdinalNumbers(value) {
    ordinalNumbers.add(value);
  }
}
