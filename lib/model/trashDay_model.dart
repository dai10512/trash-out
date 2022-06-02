import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:uuid/uuid.dart';

final trashDayModelProvider = ChangeNotifierProvider<TrashDayModel>(
  (ref) => TrashDayModel(),
);

Uuid uuid = const Uuid();

class TrashDayModel extends ChangeNotifier {
  String id = '';
  String trashType = '';
  Map<int, bool> daysOfTheWeek = {};
  Map<int, bool> ordinalNumbers = {};

  // listから選んだ場合は、DBのkeyからloadedTrashDayを引数に。ない場合に上記DefaultTrashDayの値をModelのパラメーターに充てて更新している。
  // 詳細ページに移る時は常にこれらが呼び出されて、フレッシュなデータになる想定である。
  // しかし、実際のところは、loadedTrashDayやdefaultTrashDayの中身ごと更新されてしまっている。
  TrashDay defaultTrashDay = TrashDay(
    id: uuid.v4(),
    trashType: '',
    daysOfTheWeek: {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false},
    ordinalNumbers: {1: false, 2: false, 3: false, 4: false, 5: false},
  );

  void loadData(TrashDay? loadedTrashDay) {
    final TrashDay model;
    if (loadedTrashDay != null) {
      model = loadedTrashDay;
      print('load form hive');
      print(loadedTrashDay.ordinalNumbers);
    } else {
      model = defaultTrashDay;
      print('load from defaultTrashDay');
      print(defaultTrashDay.ordinalNumbers);
    }
    id = model.id;
    trashType = model.trashType;
    daysOfTheWeek = model.daysOfTheWeek;
    ordinalNumbers = model.ordinalNumbers;
    print('loaded');
  }

  // こちらはビルドするタイミングなのでnotifyLisnerは不要とのこと

  void resetDefaultTrashDay() {
    defaultTrashDay = TrashDay(
      id: uuid.v4(),
      trashType: '',
      daysOfTheWeek: {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false},
      ordinalNumbers: {1: false, 2: false, 3: false, 4: false, 5: false},
    );
    notifyListeners();
  }

  void resetLoadedTrashDay(TrashDay loadedTrashDay) {
    loadedTrashDay = TrashDay(
      id: loadedTrashDay.id,
      trashType: loadedTrashDay.trashType,
      daysOfTheWeek: loadedTrashDay.daysOfTheWeek,
      ordinalNumbers: loadedTrashDay.ordinalNumbers,
    );
  }

  void updateTrashType(String text) {
    trashType = text;
    notifyListeners();
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
