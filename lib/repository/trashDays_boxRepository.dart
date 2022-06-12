import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

TrashDaysBoxRepository trashDaysBoxRepository = TrashDaysBoxRepository();

class TrashDaysBoxRepository {
  Box<dynamic> box = Hive.box<TrashDay>('TrashDay');

  List<TrashDay> getTrashDays() {
    List<TrashDay> trashDays = box.values.toList().cast<TrashDay>();
    return trashDays;
  }

  TrashDay? getTrashDay(hiveKey) {
    TrashDay? trashDay = box.get(hiveKey);
    return trashDay;
  }

  Future<void> addTrashDay(TrashDay tempTrashDay) async {
    box.add(tempTrashDay).then(
          (value) => print('added'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> updateTrashType(dynamic hiveKey, TrashDay tempTrashDay) async {
    box.put(hiveKey, tempTrashDay).then(
          (value) => print('updated'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> deleteTrashDay(hiveKey) async {
    box.delete(hiveKey).then(
          (value) => print('deleted'),
          onError: (e) => print("$e}"),
        );
  }
}
