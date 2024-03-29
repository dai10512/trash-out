import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
SharedPreferences? prefs;
/////////////////////////////////////////////
///レイアウト
const double commonHorizontalPadding = 20.0;
const double commonElevation = 5;
const double totalPadding = 20;
/////////////////////////////////////////////
///色
final cardTextColor = Colors.blueGrey[800];
final cardTextColorOff = cardTextColor!.withOpacity(0.4);
final buttonTopLeftColor = Colors.orange[600];
final buttonRightColor = Colors.orange[300];
final topLeftColor = Colors.blue[300];
final bottomRightColor = Colors.blue[100];
/////////////////////////////////////////////
///グラディエント
final commonGradient = LinearGradient(
  colors: [topLeftColor!, bottomRightColor!],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final cardGradient = LinearGradient(
  colors: [topLeftColor!.withOpacity(0.5), bottomRightColor!.withOpacity(0.5)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final cardGradientOff = LinearGradient(
  colors: [topLeftColor!.withOpacity(0.2), bottomRightColor!.withOpacity(0.2)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final buttonGradient = LinearGradient(
  colors: [
    buttonTopLeftColor!.withOpacity(0.5),
    buttonRightColor!.withOpacity(0.5)
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

///////////////////////////////////////////

final formatWeekdayMap = {
  1: '月曜日',
  2: '火曜日',
  3: '水曜日',
  4: '木曜日',
  5: '金曜日',
  6: '土曜日',
  7: '日曜日',
};

// final Map<int, String> formatWeekOfMonthMap = {
//   1: '第1',
//   2: '第2',
//   3: '第3',
//   4: '第4',
//   5: '第5',
// };

String formatWeeksOfMonth(Map<int, bool> weeksOfMonth) {
  String word = '';
  int count = 0;
  for (var i = 1; i <= weeksOfMonth.length; i++) {
    if (weeksOfMonth[i]!) {
      word += '第$i、';
      count++;
    }
  }

  switch (count) {
    case 0:
      word = '週が未登録です';
      break;
    case 5:
      word = '毎週';
      break;
    default:
      word = '毎月${word.substring(0, word.length - 1)}';
  }
  return word;
}

String formatWeekdays(Map<int, bool> daysOfWeek) {
  String word = '';
  int count = 0;
  for (var i = 1; i <= daysOfWeek.length; i++) {
    if (daysOfWeek[i]!) {
      word += '${formatWeekdayMap[i]}、';
      count++;
    }
  }
  switch (count) {
    case 0:
      word = '週が未登録です';
      break;
    default:
      word = word.substring(0, word.length - 1);
  }

  return word;
}

String formatWhichDay(int whichDay) {
  String text = '';
  if (whichDay == 0) {
    text = '今日';
  } else {
    text = '明日';
  }
  return text;
}

List<int> mapToList(Map map) {
  final List<int> keys = [];
  for (var i = 1; i <= map.length; i++) {
    if (map[i]) {
      keys.add(i);
    }
  }
  return keys;
}
