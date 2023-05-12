import 'package:freezed_annotation/freezed_annotation.dart';

part 'trash_info.freezed.dart';
part 'trash_info.g.dart';

@freezed
abstract class TrashInfo with _$TrashInfo {
  const factory TrashInfo({
    required String id,
    required String trashType,
    required Map<int, bool> daysOfWeek,
    required Map<int, bool> weeksOfMonth,
  }) = _TrashInfo;

  factory TrashInfo.fromJson(Map<String, dynamic> json) =>
      _$TrashInfoFromJson(json);

  //　毎週〇〇曜日を表示
  // get weeksOfMonthStr {
  //   weeksOfMonth.removeWhere((_, value) => value == false);
  //   final weeksOfMonthList = weeksOfMonth.keys.toList();
  //   final weeksOfMonthStr = '毎月第${weeksOfMonthList.join(',第')}';
  //   return weeksOfMonthStr;
  // }
}
