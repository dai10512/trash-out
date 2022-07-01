import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Uuid uuid = const Uuid();

DateTime now = DateTime.now();
DateTime after24h = now.add(const Duration(days: 1));

DateFormat outputFormat = DateFormat('yMMMd', 'ja');

String today = outputFormat.format(now);
String tomorrow = outputFormat.format(after24h);

double commonHorizontalPadding = 20.0;
double commonElevation = 5;
Color? cardTextColor = Colors.blueGrey[800];
Color? cardTextColorOff = cardTextColor!.withOpacity(0.4);
Color? buttonTopLeftColor = Colors.orange[600];
Color? buttonRightColor = Colors.orange[300];

Color? topLeftColor = Colors.blue[300];
Color? bottomRightColor = Colors.blue[100];

LinearGradient commonGradient = LinearGradient(
  colors: [topLeftColor!, bottomRightColor!],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

LinearGradient cardGradient = LinearGradient(
  colors: [topLeftColor!.withOpacity(0.5), bottomRightColor!.withOpacity(0.5)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

LinearGradient cardGradientOff = LinearGradient(
  colors: [topLeftColor!.withOpacity(0.2), bottomRightColor!.withOpacity(0.2)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

LinearGradient buttonGradient = LinearGradient(
  colors: [buttonTopLeftColor!.withOpacity(0.5), buttonRightColor!.withOpacity(0.5)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const double totalPadding = 20;

class CoolDivider extends StatelessWidget {
  const CoolDivider({
    Key? key,
    this.height = 16,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    required this.gradient,
  }) : super(key: key);

  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height),
        Container(
          height: thickness,
          margin: EdgeInsetsDirectional.only(
            start: indent,
            end: endIndent,
          ),
          decoration: BoxDecoration(gradient: commonGradient),
        ),
      ],
    );
  }
}

final Map<int, String> formatWeekdayMap = {
  1: '月曜日',
  2: '火曜日',
  3: '水曜日',
  4: '木曜日',
  5: '金曜日',
  6: '土曜日',
  7: '日曜日',
};

final Map<int, String> formatWeekOfMonthMap = {
  1: '第1',
  2: '第2',
  3: '第3',
  4: '第4',
  5: '第5',
};

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
