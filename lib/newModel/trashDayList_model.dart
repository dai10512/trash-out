import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/repository/boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

final trashDayListModelProvider = ChangeNotifierProvider<TrashDayListModel>((ref) => TrashDayListModel());

class TrashDayListModel extends ChangeNotifier {
  List<TrashDay> trashDays = [];

  List<TrashDay> getTrashDays() {
    trashDays = boxRepository.getTrashDays();
    return trashDays;
  }

  void deleteTrashDay(dynamic hiveKey) {
    boxRepository.deleteTrashDay(hiveKey);
  }
}
