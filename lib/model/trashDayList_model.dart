import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/main.dart';

class Boxes {
  static Box<TrashDay> getTrashDays() => Hive.box<TrashDay>('TrashDays');
}

final trashDayListModelProvider = ChangeNotifierProvider<TrashDayListModel>(
  (ref) => TrashDayListModel(),
);

class TrashDayListModel extends ChangeNotifier {
  TrashDayListRepository trashDayListRepository = TrashDayListRepository();

  void addTrashDay(id, trashType, daysOfTheWeek, ordinalNumbers) {
    trashDayListRepository.addTrashDayListRepository(id, trashType, daysOfTheWeek, ordinalNumbers);
  }

  void deleteTrashDay(trashDay, trashDays, index) {
    trashDayListRepository.deleteTrashDayListRepository(trashDay, trashDays, index);
  }
}

class TrashDayListRepository {
  Future addTrashDayListRepository(id, trashType, daysOfTheWeek, ordinalNumbers) async {
    final trashDay = TrashDay(
      id: id,
      trashType: trashType,
      daysOfTheWeek: daysOfTheWeek,
      ordinalNumbers: ordinalNumbers,
    );
    print('newTrashDay');
    final box = Boxes.getTrashDays();
    box.add(trashDay).then((value) => print('added'));
    print(trashDay.trashType);
    print(trashDay.id);
  }

  void deleteTrashDayListRepository(trashDay, List trashDays, index) async {
    final box = Boxes.getTrashDays();
    box.deleteAt(index).then((value) => print('deleted'));
  }
}
