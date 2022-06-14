import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/modelAndController/trashOfDay_model.dart';
import 'package:trash_out/typeAdapter/trashOfDay.dart';

TrashOfDayBoxRepository trashOfDayBoxRepository = TrashOfDayBoxRepository();

class TrashOfDayBoxRepository {
  Box<dynamic> box = Hive.box<TrashOfDay>('TrashOfDay');

  // List<TrashOfDay> getTrashOfDayList() {
  //   List<TrashOfDay> trashOfDayList = box.values.toList().cast<TrashOfDay>();
  //   return trashOfDayList;
  // }

  // TrashOfDay? getTrash(hiveKey) {
  //   TrashOfDay? trashOfDay = box.get(hiveKey);
  //   return trashOfDay;
  // }

  // Future<void> addTrashOfDay(int scheduleNumber, String totalTrashType) async {
  //   box.put(scheduleNumber,totalTrashType).then(
  //         (value) => print('added'),
  //         onError: (e) => print("$e}"),
  //       );
  // }

  Future<void> addTrashOfDay(TrashOfDay tempTrashOfDay) async {
    box.add(tempTrashOfDay).then(
          (value) => print('added'),
          onError: (e) => print("$e}"),
        );
  }

  // Future<void> deleteTrashOfDay(hiveKey) async {
  //   box.delete(hiveKey).then(
  //         (value) => print('deleted'),
  //         onError: (e) => print("$e}"),
  //       );
  // }
}
