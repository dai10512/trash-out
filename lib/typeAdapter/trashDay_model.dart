import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/main.dart';

final trashDayModelProvider = ChangeNotifierProvider<TrashDayModel>(
  (ref) => TrashDayModel(),
);

class TrashDayModel extends ChangeNotifier {
  TrashDayRepository trashDayRepository = TrashDayRepository();

  void addTrashDay(id, trashType, daysOfTheWeek, ordinalNumbers) {
    trashDayRepository.addTrashDayRepository(id, trashType, daysOfTheWeek, ordinalNumbers);
  }

  void deleteTrashDay(trashDay, trashDays, index) {
    trashDayRepository.deleteTrashDayRepository(trashDay, trashDays, index);
  }
}

class TrashDayRepository {
  Future addTrashDayRepository(id, trashType, daysOfTheWeek, ordinalNumbers) async {
    final trashDay = TrashDay(
      id: id,
      trashType: trashType,
      daysOfTheWeek: daysOfTheWeek,
      ordinalNumbers: ordinalNumbers,
    );

    final box = Boxes.getTrashDays();
    box.add(trashDay);
    print('added');
  }

  void deleteTrashDayRepository(trashDay, List trashDays, index) async {
    final box = Boxes.getTrashDays();
    print(box);

    box.deleteAt(index);
    print('deleted');
  }
}
