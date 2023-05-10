import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../modelAndController/trashOfDay_model.dart';
import '../modelAndController/trash_model.dart';
import '../repository/trashList_boxRepository.dart';
import '../typeAdapter/trash.dart';
import '../util/util.dart';
import 'notification_setting_view.dart';
import 'trash_detail_view.dart';

class TrashListView extends ConsumerStatefulWidget {
  const TrashListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<TrashListView> {
  @override
  Widget build(BuildContext context) {
    final appBarIconList = [
      IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.add),
        onPressed: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (_) => const TrashDetailView(null),
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
        padding: EdgeInsets.symmetric(horizontal: commonHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            buildHeadline('収集ゴミの案内'),
            buildTrashOfDaySection(context),
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

  Widget buildTrashOfDaySection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildTrashOfDayCard(0),
        const SizedBox(width: 7),
        buildTrashOfDayCard(1),
      ],
    );
  }

  Widget buildTrashOfDayCard(
    int whichDay,
  ) {
    final trashOfDayViewModelWatch =
        ref.watch(trashOfDayViewModelProvider); //必要
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
                formatWhichDay(whichDay),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: cardTextColor),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FutureBuilder(
                  future: whichDay == 0
                      ? trashOfDayViewModelWatch.getTotalTrashTypeOfToday()
                      : trashOfDayViewModelWatch.getTotalTrashTypeOfTomorrow(),
                  builder: (context, snapshot) {
                    return FittedBox(
                      child: snapshot.hasData
                          ? Text(
                              snapshot.data.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: cardTextColor),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "無し",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: Colors.blueGrey[700]),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
    return trashList.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                '収集ゴミが未登録です。\n右上の「＋」ボタンを押して\nリストを作成しましょう',
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
              // reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: trashList.length,
              itemBuilder: (context, index) {
                final trash = trashList[index];
                final hiveKey = trashListBoxRepository.box.keyAt(index);
                return _buildSlidableListTile(trash, hiveKey);
              },
            ),
          );
  }

  Widget _buildSlidableListTile(
    Trash trash,
    dynamic hiveKey,
  ) {
    final trashModel = ref.read(trashModelProvider(hiveKey));
    final trashOfDayViewModelRead = ref.read(trashOfDayViewModelProvider);

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        await trashModel.deleteTrash(hiveKey);
        await trashOfDayViewModelRead.setTotalTrashType();
      },
      child: Card(
        elevation: commonElevation,
        child: Container(
          decoration: BoxDecoration(
              gradient: cardGradient,
              borderRadius: BorderRadius.circular(10.0)),
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
              showModalBottomSheet(
                  context: context,
                  builder: (context) => TrashDetailView(hiveKey));
            },
          ),
        ),
      ),
    );
  }
}
