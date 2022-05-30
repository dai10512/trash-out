import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

class TrashDayModel extends ChangeNotifier {
  String id = '';
  String trashType = '';
  List<int> daysOfTheWeek = [];
  List<int> ordinalNumbers = [];

  TrashDaydayRepository trashDaydayRepository = TrashDaydayRepository();

  // void addTrashDay(id, trashType, daysOfTheWeek, ordinalNumbers) {
  //   trashDaydayRepository.addTrashDaydayRepository(id, trashType, daysOfTheWeek, ordinalNumbers);
  // }

}

class TrashDaydayRepository {
  Future addTrashDaydayRepository(id, trashType, daysOfTheWeek, ordinalNumbers) async {}
}
