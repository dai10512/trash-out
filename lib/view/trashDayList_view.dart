import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/modelAndController/trashDay_model.dart';
import 'package:trash_out/repository/trashDays_boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/util/util.dart';
import 'package:trash_out/view/notificationSetting_view.dart';
import 'package:trash_out/view/trashDay_view.dart';
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
          itemCount: trashDays.length,
          itemBuilder: (BuildContext context, int index) {
            final trashDay = trashDays[index];
            final hiveKey = trashDaysBoxRepository.box.keyAt(index);
            return _buildSlidableListTile(trashDay, hiveKey);
          },
        ),
      );
    }
  }

  Widget _buildSlidableListTile(TrashDay trashDay, dynamic hiveKey) {
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
              title: Text((trashDay.trashType != '') ? trashDay.trashType : '種類が登録されていません'),
              subtitle: Text('${formatWeeksOfMonth(trashDay.weeksOfMonth)}  /  ${formatWeekdays(trashDay.daysOfWeek)}'),
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
