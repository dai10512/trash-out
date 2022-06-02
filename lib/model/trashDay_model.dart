import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:uuid/uuid.dart';

final trashDayModelProvider = ChangeNotifierProvider<TrashDayModel>(
  (ref) => TrashDayModel(),
);

Uuid uuid = const Uuid();

final defaultTrashDay = TrashDay(
  id: uuid.v4(),
  trashType: '',
  daysOfTheWeek: {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false},
  ordinalNumbers: {1: false, 2: false, 3: false, 4: false, 5: false},
);

class TrashDayModel extends ChangeNotifier {
  String id = '';
  String trashType = '';
  Map<int, bool> daysOfTheWeek = {};
  Map<int, bool> ordinalNumbers = {};

  void loadData(TrashDay? loadedTrashDay) {
    final TrashDay model;
    if (loadedTrashDay != null) {
      model = loadedTrashDay;
    } else {
      model = defaultTrashDay;
    }
    id = model.id;
    trashType = model.trashType;
    daysOfTheWeek = model.daysOfTheWeek;
    ordinalNumbers = model.ordinalNumbers;
  }
  // こちらはビルドするタイミングなのでnotifyLisnerは不要とのこと

  void updateTrashType(String text) {
    trashType = text;
    // controllerで反映されるからnotifyLisnerは不要と思われる
  }

  void updateDaysOfTheWeek(int index) {
    daysOfTheWeek[index] = !daysOfTheWeek[index]!;
    notifyListeners();
  }

  void updateOrdinalNumbers(int index) {
    ordinalNumbers[index] = !ordinalNumbers[index]!;
    notifyListeners();
  }
}
