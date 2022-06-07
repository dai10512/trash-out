import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/model/trashDay_model.dart';
import 'package:trash_out/repository/trashDays_boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/view/trashDayNotifications_view.dart';
import 'package:trash_out/view/trashDay_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TrashDayListView extends ConsumerWidget {
  const TrashDayListView({Key? key}) : super(key: key);
  // final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('登録アイテム', style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => const TrashDetailView(null),
                        );
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationSettingView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            ValueListenableBuilder<Box<dynamic>>(
              valueListenable: trashDaysBoxRepository.box.listenable(),
              builder: (context, box, _) {
                List<TrashDay> trashDays = box.values.toList().cast<TrashDay>();
                return buildContent(trashDays);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildContent(List<TrashDay> trashDays) {
    if (trashDays.isEmpty) {
      return Column(
        children: const [
          SizedBox(height: 300),
          Text('データがありません'),
        ],
      );
    } else {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: trashDays.length,
          itemBuilder: (BuildContext context, int index) {
            final trashDay = trashDays[index];
            final hiveKey = trashDaysBoxRepository.box.keyAt(index);
            return buildSlidableListTile(trashDay, hiveKey);
          },
        ),
      );
    }
  }

  Widget buildSlidableListTile(TrashDay trashDay, dynamic hiveKey) {
    return Consumer(
      builder: (context, ref, child) {
        final TrashDayModel trashDayModel = ref.read(trashDayModelProvider(hiveKey));
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            trashDayModel.deleteTrashDay(hiveKey);
          },
          child: Card(
            child: ListTile(
              title: Text((trashDay.trashType != '') ? '${trashDay.trashType}' : '種類が登録されていません'),
              subtitle: Text('${formatOrdinalNumber(trashDay.weeksOfMonth)}  /  ${formatDayOfTheWeek(trashDay.daysOfWeek)}'),
              // trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => TrashDetailView(hiveKey),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

String formatOrdinalNumber(Map<int, bool> weeksOfMonth) {
  String word = '';
  int count = 0;
  for (var i = 1; i <= weeksOfMonth.length; i++) {
    if (weeksOfMonth[i]!) {
      word += '第$i、';
      count++;
    }
  }
  if (count == 0) {
    word = '週が未登録です';
  } else if (count == 5) {
    word = '毎週';
  } else {
    word = word.substring(0, word.length - 1);
  }
  return word;
}

String formatDayOfTheWeek(Map<int, bool> daysOfWeek) {
  String word = '';
  int count = 0;
  for (var i = 1; i <= daysOfWeek.length; i++) {
    if (daysOfWeek[i]!) {
      word += '${dayOfTheWeekMap[i]}、';
      count++;
    }
  }

  if (count == 0) {
    word = '曜日が未登録です';
  } else {
    word = word.substring(0, word.length - 1);
  }
  return word;
}

Map<int, String> dayOfTheWeekMap = {
  1: '月曜日',
  2: '火曜日',
  3: '水曜日',
  4: '木曜日',
  5: '金曜日',
  6: '土曜日',
  7: '日曜日',
};
