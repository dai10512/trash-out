import 'package:freezed_annotation/freezed_annotation.dart';

part 'trash_info.freezed.dart';

@freezed
abstract class TrashInfo with _$TrashInfo {
  const factory TrashInfo({
    @Default('')
        String trashType,
    @Default({
      1: false,
      2: false,
      3: false,
      4: false,
      5: false,
      6: false,
      7: false
    })
        Map<int, bool> daysOfWeek,
    @Default({
      1: true,
      2: true,
      3: true,
      4: true,
      5: true,
    })
        Map<int, bool> weeksOfMonth,
  }) = _TrashInfo;

  //　毎週〇〇曜日を表示
  // get weeksOfMonthStr {
  //   weeksOfMonth.removeWhere((_, value) => value == false);
  //   final weeksOfMonthList = weeksOfMonth.keys.toList();
  //   final weeksOfMonthStr = '毎月第${weeksOfMonthList.join(',第')}';
  //   return weeksOfMonthStr;
  // }
}
