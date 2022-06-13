import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/modelAndController/trash_model.dart';
import 'package:trash_out/repository/trashList_boxRepository.dart';
import 'package:trash_out/typeAdapter/trash.dart';
import 'package:trash_out/util/util.dart';
import 'package:trash_out/view/notificationSetting_view.dart';
import 'package:trash_out/view/trash_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TrashDayListView extends ConsumerWidget {
  const TrashDayListView({Key? key}) : super(key: key);
  // final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ref) {
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
        title: const Text('収集ゴミリスト'),
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
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Column(
          children: [
            ValueListenableBuilder<Box<dynamic>>(
              valueListenable: trashDaysBoxRepository.box.listenable(),
              builder: (context, box, _) {
                List<Trash> trashList = box.values.toList().cast<Trash>();
                return buildContent(trashList);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildContent(List<Trash> trashList) {
    if (trashList.isEmpty) {
      return Center(
        child: Column(
          children: const [
            SizedBox(height: 300),
            Text('データがありません'),
          ],
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
            final hiveKey = trashDaysBoxRepository.box.keyAt(index);
            return _buildSlidableListTile(trash, hiveKey);
          },
        ),
      );
    }
  }

  Widget _buildSlidableListTile(Trash trash, dynamic hiveKey) {
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
