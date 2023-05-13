import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trash_out/model/trash_info.dart';
import 'package:trash_out/model/trash_info_list_service.dart';
import 'package:trash_out/model/trash_of_day.dart';

part 'trash_of_day_service.g.dart';

@riverpod
class TrashOfDayListService extends _$TrashOfDayListService {
  @override
  FutureOr<List<TrashOfDay?>?> build() async {
    final result = await fetch();
    print(result);
    return result;
  }

  TrashInfoListService get trashInfoListServiceNotifier =>
      ref.read(trashInfoListServiceProvider.notifier);
  List<TrashInfo?>? get currentTrashInfoList =>
      trashInfoListServiceNotifier.currentTrashInfoList;

  Future<List<TrashOfDay>> fetch() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      fetchTrashOfDay(TargetDay.today),
      fetchTrashOfDay(TargetDay.tomorrow),
    ];
  }

  TrashOfDay fetchTrashOfDay(TargetDay targetDay) {
    final today = DateTime.now().subtract(
      Duration(days: targetDay.addDay),
    );
    final todayWeekOfMonth = (today.day ~/ 7) + 1;
    final todayWeekday = today.weekday;

    List<String> totalTrashTypeOfToday = [];

    currentTrashInfoList!.map((e) {
      final hasMatchedDayOfWeek = e!.daysOfWeek[todayWeekday] == true;
      final hasMatchedWeekOfMonth = e.weeksOfMonth[todayWeekOfMonth] == true;
      if (!hasMatchedDayOfWeek) {
        return;
      }
      if (!hasMatchedWeekOfMonth) {
        return;
      }

      return totalTrashTypeOfToday.add(e.trashType);
    }).toList();

    String trashTypeListStr = totalTrashTypeOfToday.join(',');
    if (trashTypeListStr == '') {
      trashTypeListStr = '無し';
    }
    return TrashOfDay(
      targetDay: targetDay,
      trashType: trashTypeListStr,
    );
  }
}
