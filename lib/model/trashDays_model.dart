import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/repository/trashDaysBox_repository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

final trashDayListModelProvider = ChangeNotifierProvider<TrashDayListModel>((ref) => TrashDayListModel());

class TrashDayListModel extends ChangeNotifier {
  List<TrashDay> trashDays = [];

  List<TrashDay> getTrashDays() {
    trashDays = trashDaysBoxRepository.getTrashDays();
    return trashDays;
  }

  void deleteTrashDay(dynamic hiveKey) {
    trashDaysBoxRepository.deleteTrashDay(hiveKey);
  }
}
