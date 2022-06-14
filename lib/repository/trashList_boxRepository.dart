import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/typeAdapter/trash.dart';

TrashListBoxRepository trashListBoxRepository = TrashListBoxRepository();

class TrashListBoxRepository {
  Box<dynamic> box = Hive.box<Trash>('Trash');

  List<Trash> getTrashList() {
    List<Trash> trashList = box.values.toList().cast<Trash>();
    return trashList;
  }

  Trash? getTrash(hiveKey) {
    Trash? trash = box.get(hiveKey);
    return trash;
  }

  Future<void> addTrash(Trash tempTrash) async {
    box.add(tempTrash).then(
          (value) => print('added'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> updateTrashType(dynamic hiveKey, Trash tempTrash) async {
    box.put(hiveKey, tempTrash).then(
          (value) => print('updated'),
          onError: (e) => print("$e}"),
        );
  }

  Future<void> deleteTrash(hiveKey) async {
    box.delete(hiveKey).then(
          (value) => print('deleted'),
          onError: (e) => print("$e}"),
        );
  }
}
