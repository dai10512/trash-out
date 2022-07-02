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

  @override
  Widget build(BuildContext context, ref) {
    // final List<Widget> appBarIconList = [
    //   IconButton(
    //     padding: EdgeInsets.zero,
    //     icon: const Icon(Icons.add),
    //     onPressed: () {
    //       showCupertinoModalBottomSheet(context: context, builder: (context) => const TrashDetailView(null));
    //     },
    //   ),
    //   IconButton(
    //     padding: EdgeInsets.zero,
    //     icon: const Icon(Icons.settings),
    //     onPressed: () {
    //       Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingView()));
    //     },
    //   ),
    // ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        centerTitle: true,
        // actions: appBarIconList,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: commonHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: 15),
            // buildHeadline('収集ゴミの案内'),
            // buildTrashOfDayCard(context, 0),
            // const SizedBox(height: 15),

            // buildTrashOfDayCard(context, 1),
            // // buildTrashOfDaySection(context),
            // const SizedBox(height: 15),
            buildHeadline('収集ゴミのリスト'),
            buildTrashListSection(),
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

  // Widget buildTrashOfDaySection(context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       buildTrashOfDayCard(context, 0),
  //       const SizedBox(width: 7),
  //       buildTrashOfDayCard(context, 1),
  //     ],
  //   );
  // }

  Widget buildTrashOfDayCard(BuildContext context, int whichDay) {
    return Consumer(
      builder: (context, ref, _) {
        final TrashOfDayViewModel trashOfDayViewModelWatch = ref.watch(trashOfDayViewModelProvider); //必要
        return Card(
          elevation: commonElevation,
          child: Container(
            decoration: BoxDecoration(gradient: cardGradient, borderRadius: BorderRadius.circular(10.0)),
            width: double.infinity,
            // width: (isMonitor) ? 280 : double.infinity,
            // padding: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Text(
                  formatWhichDay(whichDay),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: cardTextColor),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FutureBuilder(
                    future: (whichDay == 0) ? trashOfDayViewModelWatch.getTotalTrashTypeOfToday() : trashOfDayViewModelWatch.getTotalTrashTypeOfTomorrow(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FittedBox(
                          child: Column(
                            children: [
                              Text(
                                (whichDay == 0) ? today.toString() : tomorrow.toString(),
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: cardTextColor),
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                children: [
                                  Text(
                                    (whichDay == 0)
                                        ? formatWeekOfMonthMap[(now.day % 7) + 1].toString()
                                        : formatWeekOfMonthMap[(after24h.day % 7) + 1].toString(),
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: cardTextColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    (whichDay == 0) ? formatWeekdayMap[now.weekday].toString() : formatWeekdayMap[after24h.weekday].toString(),
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: cardTextColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Text(
                                snapshot.data.toString(),
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: cardTextColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return FittedBox(
                          child: Text(
                            "無し",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.blueGrey[700]),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
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
          // reverse: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
        final TrashOfDayViewModel trashOfDayViewModelRead = ref.read(trashOfDayViewModelProvider);
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) async {
            await trashModel.deleteTrash(hiveKey);
            await trashOfDayViewModelRead.setTotalTrashType();
          },
          child: Card(
            elevation: commonElevation,
            child: Container(
              decoration: BoxDecoration(gradient: cardGradient, borderRadius: BorderRadius.circular(10.0)),
              // width: (isMonitor) ? 280 : double.infinity,
              padding: const EdgeInsets.all(0.0),
              child: ListTile(
                title: Text(
                  (trash.trashType != '') ? trash.trashType : '種類が登録されていません',
                  style: TextStyle(color: cardTextColor),
                ),
                subtitle: Text(
                  '${formatWeeksOfMonth(trash.weeksOfMonth)}  /  ${formatWeekdays(trash.weekdays)}',
                  style: TextStyle(color: cardTextColor),
                ),
                onTap: () {
                  showCupertinoModalBottomSheet(context: context, builder: (context) => TrashDetailView(hiveKey));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
