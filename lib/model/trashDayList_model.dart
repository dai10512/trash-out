import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/model/trashDay_model.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

class Boxes {
  static Box<TrashDay> getTrashDays() => Hive.box<TrashDay>('TrashDays');
}

final trashDayListModelProvider = ChangeNotifierProvider<TrashDayListModel>((ref) => TrashDayListModel());

class TrashDayListModel extends ChangeNotifier {
  TrashDayListRepository trashDayListRepository = TrashDayListRepository();

  void addTrashDay(
    TrashDayModel trashDayRead,
  ) {
    trashDayListRepository.addTrashDayListRepository(trashDayRead);
  }

  void loadTrashDay(
    dynamic hiveKey,
  ) {
    trashDayListRepository.loadTrashDayListRepository(hiveKey);
  }

  void updateTrashDay(
    int index,
    TrashDayModel trashDayRead,
  ) {
    trashDayListRepository.updateTrashDayListRepository(index, trashDayRead);
  }

  void deleteTrashDay(
    List trashDays,
    int index,
  ) {
    trashDayListRepository.deleteTrashDayListRepository(trashDays, index);
  }
}

class TrashDayListRepository {
  Future addTrashDayListRepository(
    TrashDayModel trashDayRead,
  ) async {
    final trashDay = TrashDay(
      id: trashDayRead.id,
      trashType: trashDayRead.trashType,
      daysOfTheWeek: trashDayRead.daysOfTheWeek,
      ordinalNumbers: trashDayRead.ordinalNumbers,
    );
    final box = Boxes.getTrashDays();
    box.add(trashDay).then((value) => print('added'));
  }

  Future loadTrashDayListRepository(
    dynamic hiveKey,
  ) async {
    final box = Boxes.getTrashDays();
    final loadedTrashDay = box.get(hiveKey);
    return loadedTrashDay;
  }

  Future updateTrashDayListRepository(
    int index,
    TrashDayModel trashDayRead,
  ) async {
    final trashDay = TrashDay(
      id: trashDayRead.id,
      trashType: trashDayRead.trashType,
      daysOfTheWeek: trashDayRead.daysOfTheWeek,
      ordinalNumbers: trashDayRead.ordinalNumbers,
    );
    final box = Boxes.getTrashDays();
    box.putAt(index, trashDay).then((value) => print('updated'));
  }

  void deleteTrashDayListRepository(
    List trashDays,
    int index,
  ) async {
    final box = Boxes.getTrashDays();
    box.deleteAt(index).then((value) => print('deleted'));
  }
}
