import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/model/trashDay_model.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

class Boxes {
  static Box<TrashDay> getTrashDays() {
    return Hive.box<TrashDay>('TrashDays');
  }
}

final trashDayListModelProvider = ChangeNotifierProvider<TrashDayListModel>((ref) => TrashDayListModel());

class TrashDayListModel extends ChangeNotifier {
  TrashDayListRepository trashDayListRepository = TrashDayListRepository();

  TrashDay? loadTrashDay(dynamic hiveKey) {
    final loadedData = trashDayListRepository.loadTrashDayListRepository(hiveKey);
    return loadedData;
  }

  void addTrashDay(TrashDayModel trashDayRead) {
    trashDayListRepository.addTrashDayListRepository(trashDayRead);
  }

  void updateTrashDay(dynamic hiveKey, TrashDayModel trashDayRead) {
    trashDayListRepository.updateTrashDayListRepository(hiveKey, trashDayRead);
  }

  void deleteTrashDay(dynamic hiveKey) {
    trashDayListRepository.deleteTrashDayListRepository(hiveKey);
  }
}

class TrashDayListRepository {
  final box = Boxes.getTrashDays();

  TrashDay? loadTrashDayListRepository(dynamic hiveKey) {
    final TrashDay? loadedTrashDay = box.get(hiveKey);
    return loadedTrashDay;
  }


  void addTrashDayListRepository(TrashDayModel trashDayRead) {
    final trashDay = TrashDay(
      id: trashDayRead.id,
      trashType: trashDayRead.trashType,
      daysOfTheWeek: trashDayRead.daysOfTheWeek,
      ordinalNumbers: trashDayRead.ordinalNumbers,
    );
    box.add(trashDay).then((value) => print('added'));
  }

  void updateTrashDayListRepository(dynamic hiveKey, TrashDayModel trashDayRead) {
    final trashDay = TrashDay(
      id: trashDayRead.id,
      trashType: trashDayRead.trashType,
      daysOfTheWeek: trashDayRead.daysOfTheWeek,
      ordinalNumbers: trashDayRead.ordinalNumbers,
    );
    box.put(hiveKey, trashDay).then((value) => print('updated'));
  }

  void deleteTrashDayListRepository(dynamic hiveKey) {
    box.delete(hiveKey).then((value) => print('deleted'));
  }
}
