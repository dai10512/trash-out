import 'package:freezed_annotation/freezed_annotation.dart';

part 'trash_of_day.freezed.dart';
part 'trash_of_day.g.dart';

@freezed
abstract class TrashOfDay with _$TrashOfDay {
  const factory TrashOfDay({
    required TargetDay targetDay,
    required String trashType,
  }) = _TrashOfDay;

  factory TrashOfDay.fromJson(Map<String, dynamic> json) =>
      _$TrashOfDayFromJson(json);

  //　毎週〇〇曜日を表示
  // get weeksOfMonthStr {
  //   weeksOfMonth.removeWhere((_, value) => value == false);
  //   final weeksOfMonthList = weeksOfMonth.keys.toList();
  //   final weeksOfMonthStr = '毎月第${weeksOfMonthList.join(',第')}';
  //   return weeksOfMonthStr;
  // }
}

enum TargetDay {
  today('今日', 0),
  tomorrow('明日', 1),
  ;

  const TargetDay(this.label, this.addDay);
  final String label;
  final int addDay;
}
