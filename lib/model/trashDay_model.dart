import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

final trashDayModelProvider = ChangeNotifierProvider<TrashDayModel>(
  (ref) => TrashDayModel(),
);

class TrashDayModel extends ChangeNotifier {
  String id = '';
  String trashType = '';
  List<int> daysOfTheWeek = [];
  List<int> ordinalNumbers = [];

  TrashDayRepository trashDayRepository = TrashDayRepository();

  void loadData(trashDay, id, trashType, daysOfTheWeek, ordinalNumbers) {
    trashDayRepository.loadDataRepository(trashDay,id, trashType, daysOfTheWeek, ordinalNumbers);
  }
}

class TrashDayRepository {
  void loadDataRepository(trashDay, id, trashType, daysOfTheWeek, ordinalNumbers) {
    if (trashDay != null) {
      id = trashDay.id;
      trashType = trashDay.trashType;
      daysOfTheWeek = trashDay.daysOfTheWeek;
      ordinalNumbers = trashDay.ordinalNumbers;
    }
  }
}
