import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/modelAndController/trashOfDay_model.dart';
import 'package:trash_out/modelAndController/trash_model.dart';
import 'package:trash_out/repository/trashList_boxRepository.dart';
import 'package:trash_out/typeAdapter/trash.dart';
import 'package:trash_out/util/util.dart';
import 'package:trash_out/view/notificationSetting_view.dart';
import 'package:trash_out/view/trash_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TrashListView extends ConsumerWidget {
  const TrashListView({Key? key}) : super(key: key);
  // final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ref) {
    print(DateTime.now());
    final List<Widget> appBarIconList = [
      IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.add),
        onPressed: () {
          showCupertinoModalBottomSheet(context: context, builder: (context) => const TrashDetailView(null));
        },
      ),
      IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.notifications),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingView()));
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        centerTitle: true,
        actions: appBarIconList,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: commonHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            buildHeadline('収集ゴミの案内'),
            buildTrashOfDaySection(context),
            const SizedBox(height: 15),
            buildHeadline('収集ゴミのリスト'),
            buildTrashListSection(),
            Consumer(builder: (context, ref, _) {
              final TrashOfDayViewModel trashOfDayViewModelRead = ref.read(trashOfDayViewModelProvider);
              final TrashOfDayViewModel trashOfDayViewModelWatch = ref.watch(trashOfDayViewModelProvider);
              return Column(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      await trashOfDayViewModelRead.setTotalTrashType();
                    },
                    child: Text(trashOfDayViewModelWatch.totalTrashTypeOfToday),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildHeadline(text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget buildTrashOfDaySection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildTrashOfDayCard(context, 0),
        const SizedBox(width: 7),
        buildTrashOfDayCard(context, 1),
      ],
    );
  }

  Widget buildTrashOfDayCard(BuildContext context, int whichDay) {
    return Consumer(
      builder: (context, ref, _) {
        final TrashOfDayViewModel trashOfDayViewModelRead = ref.read(trashOfDayViewModelProvider);
        final TrashOfDayViewModel trashOfDayViewModelWatch = ref.watch(trashOfDayViewModelProvider);
        // trashOfDayViewModelRead.setTotalTrashType();
        print(trashOfDayViewModelRead.totalTrashTypeOfToday);
        // print(1);
        return Expanded(
          child: SizedBox(
            height: 200,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(children: [
                  Text(
                    (whichDay == 0) ? '今日' : '明日',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 5),
                  FittedBox(
                    child: StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          return Text(
                            (whichDay == 0) ? trashOfDayViewModelWatch.totalTrashTypeOfToday : trashOfDayViewModelWatch.totalTrashTypeOfTomorrow,
                            style: Theme.of(context).textTheme.headlineSmall,
                          );
                        }),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await trashOfDayViewModelRead.setTotalTrashType();
                    },
                    child: Text(trashOfDayViewModelWatch.totalTrashTypeOfToday),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTrashListSection() {
    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: trashListBoxRepository.box.listenable(),
      builder: (context, box, _) {
        List<Trash> trashList = box.values.toList().cast<Trash>();
        return buildContent(trashList);
      },
    );
  }

  Widget buildContent(List<Trash> trashList) {
    if (trashList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            '収集ゴミが未登録です。\n右上の「＋」ボタンを押して\nリストを作成しましょう',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: trashList.length,
          itemBuilder: (BuildContext context, int index) {
            final trash = trashList[index];
            final hiveKey = trashListBoxRepository.box.keyAt(index);
            return _buildSlidableListTile(trash, hiveKey);
          },
        ),
      );
    }
  }

  Widget _buildSlidableListTile(Trash trash, dynamic hiveKey) {
    return Consumer(
      builder: (context, ref, child) {
        final TrashModel trashModel = ref.read(trashModelProvider(hiveKey));
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            trashModel.deleteTrash(hiveKey);
          },
          child: Card(
            child: ListTile(
              title: Text((trash.trashType != '') ? trash.trashType : '種類が登録されていません'),
              subtitle: Text('${formatWeeksOfMonth(trash.weeksOfMonth)}  /  ${formatWeekdays(trash.weekdays)}'),
              onTap: () {
                showCupertinoModalBottomSheet(context: context, builder: (context) => TrashDetailView(hiveKey));
              },
            ),
          ),
        );
      },
    );
  }
}

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
      word += '${weekdayMap[i]}、';
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
