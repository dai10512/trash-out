import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/typeAdapter/trash.dart';

TrashDaysBoxRepository trashDaysBoxRepository = TrashDaysBoxRepository();

class TrashDaysBoxRepository {
  Box<dynamic> box = Hive.box<Trash>('Trash');

  List<Trash> getTrashDays() {
    List<Trash> trashList = box.values.toList().cast<Trash>();
    return trashList;
  }

  Trash? getTrashDay(hiveKey) {
    Trash? trash = box.get(hiveKey);
    return trash;
  }

  Future<void> addTrashDay(Trash tempTrashDay) async {
    box.add(tempTrashDay).then(
          (value) => print('added'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> updateTrashType(dynamic hiveKey, Trash tempTrashDay) async {
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
