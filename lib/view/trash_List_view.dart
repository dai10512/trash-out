import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/model/trash_info_list_service.dart';
import 'package:trash_out/model/trash_of_day_service.dart';

import '../model/trash_info.dart';
import '../model/trash_of_day.dart';
// import '../modelAndController/trash_model.dart';
// import '../repository/trashList_boxRepository.dart';
// import '../typeAdapter/trash.dart';
import '../util/util.dart';
import 'notification_setting_view.dart';
import 'trash_detail_view.dart';

class TrashListView extends ConsumerStatefulWidget {
  const TrashListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<TrashListView> {
  TrashInfoListService get trashInfoListServiceNotifier =>
      ref.watch(trashInfoListServiceProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final appBarIconList = [
      IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => const TrashDetailView(null),
            ),
          );
        },
      ),
      IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NotificationSettingView(),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        centerTitle: true,
        actions: appBarIconList,
      ),
      body: buildBody(),
    );
  }

//レイアウト
  Widget buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: commonHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            buildHeadline('収集ゴミの案内'),
            buildTrashOfDaySection(),
            const SizedBox(height: 15),
            buildHeadline('収集ゴミのリスト'),
            buildTrashListSection(),
          ],
        ),
      ),
    );
  }

//見出し
  Widget buildHeadline(text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget buildTrashOfDaySection() {
    final asyncValue = ref.watch(trashOfDayListServiceProvider);
    return asyncValue.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (e, __) {
        return Text(e.toString());
      },
      data: (trashOfDayList) {
        if (trashOfDayList == null) {
          return const Text('なんか変だよ');
        }
        if ((trashOfDayList).isEmpty) {
          return const Text('なんか変だよ');
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildTrashOfDayCard(trashOfDayList[0]!),
            const SizedBox(width: 7),
            buildTrashOfDayCard(trashOfDayList[1]!),
          ],
        );
        // return ListView.builder(
        //     scrollDirection: Axis.vertical,
        //     itemCount: trashOfDayList.length,
        //     itemBuilder: (context, index) {
        //       return buildTrashOfDayCard(trashOfDayList[index]!);
        //     });
      },
    );
  }

  Widget buildTrashOfDayCard(
    TrashOfDay trashOfDay,
  ) {
    return Expanded(
      child: Card(
        elevation: commonElevation,
        child: Container(
          decoration: BoxDecoration(
              gradient: cardGradient,
              borderRadius: BorderRadius.circular(10.0)),
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              Text(
                trashOfDay.targetDay.label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: cardTextColor),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                // child: FutureBuilder(
                //   future: whichDay == 0
                //       ? trashOfDayViewModelWatch.getTotalTrashTypeOfToday()
                //       : trashOfDayViewModelWatch.getTotalTrashTypeOfTomorrow(),
                //   builder: (context, snapshot) {
                child: FittedBox(
                    child: Text(
                  trashOfDay.trashType,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: cardTextColor),
                  textAlign: TextAlign.center,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTrashListSection() {
    final asyncValue = ref.watch(trashInfoListServiceProvider);
    return asyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, __) => Text(error.toString()),
      data: (trashInfoList) {
        if (trashInfoList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                '収集ゴミが未登録です。\n右上の「＋」ボタンを押して\nリストを作成しましょう',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Expanded(
          child: ListView.builder(
            // reverse: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: trashInfoList.length,
            itemBuilder: (context, index) {
              // final trash = trashInfoList[index];
              // final hiveKey = trashListBoxRepository.box.keyAt(index);
              return _buildSlidableListTile(trashInfoList[index]!);
            },
          ),
        );
      },
    );
  }

  Widget _buildSlidableListTile(
    TrashInfo trashInfo,
  ) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) async {
        trashInfoListServiceNotifier.delete(trashInfo);
        ref.invalidate(trashInfoListServiceProvider);
        ref.invalidate(trashOfDayListServiceProvider);
      },
      child: Card(
        elevation: commonElevation,
        child: Container(
          decoration: BoxDecoration(
            gradient: cardGradient,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(0.0),
          child: ListTile(
            title: Text(
              (trashInfo.trashType != '')
                  ? trashInfo.trashType
                  : '種類が登録されていません',
              style: TextStyle(color: cardTextColor),
            ),
            subtitle: Text(
              '${formatWeeksOfMonth(trashInfo.weeksOfMonth)}'
              '/'
              '${formatWeekdays(trashInfo.daysOfWeek)}',
              style: TextStyle(color: cardTextColor),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => TrashDetailView(trashInfo),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
