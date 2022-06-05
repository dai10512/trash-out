import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

TrashDaysBoxRepository trashDaysBoxRepository = TrashDaysBoxRepository();

class TrashDaysBoxRepository {
  Box<dynamic> box = Hive.box<TrashDay>('TrashDays');

  List<TrashDay> getTrashDays() {
    List<TrashDay> trashDays = box.values.toList().cast<TrashDay>();
    return trashDays;
  }

  TrashDay? getTrashDay(hiveKey) {
    TrashDay? trashDay = box.get(hiveKey);
    return trashDay;
  }



  void addTrashDay(TrashDay tempTrashDay) {
    box.add(tempTrashDay).then((value) => print('added'));
  }

  void updateTrashType(dynamic hiveKey, TrashDay tempTrashDay) {
    box.put(hiveKey, tempTrashDay).then((value) => print('updated'));
  }

  void deleteTrashDay(hiveKey) {
    box.delete(hiveKey);
  }
}
