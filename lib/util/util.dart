import 'package:uuid/uuid.dart';


List<int> mapToList(Map map) {
  final List<int> keys = [];
  for (var i = 1; i <= map.length; i++) {
    if (map[i]) {
      keys.add(i);
    }
  }
  return keys;
}

const uuid =  Uuid();

final Map<int,String>weekdayMap = {
  1: '月曜日',
  2: '火曜日',
  3: '水曜日',
  4: '木曜日',
  5: '金曜日',
  6: '土曜日',
  7: '日曜日',
};

