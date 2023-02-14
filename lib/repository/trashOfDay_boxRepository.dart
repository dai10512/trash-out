import 'package:hive_flutter/hive_flutter.dart';

import '../typeAdapter/trashOfDay.dart';

TrashOfDayBoxRepository trashOfDayBoxRepository = TrashOfDayBoxRepository();

class TrashOfDayBoxRepository {
  Box<dynamic> box = Hive.box<TrashOfDay>('TrashOfDay');

  List<TrashOfDay> getTrashOfDayList() {
    List<TrashOfDay> trashOfDayList = box.values.toList().cast<TrashOfDay>();
    return trashOfDayList;
  }

  Future<void> addTrashOfDay(TrashOfDay tempTrashOfDay) async {
    await box.add(tempTrashOfDay);
  }

  Future<void> clearTrashOfDay() async {
    await box.clear();
  }
}
