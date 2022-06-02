import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/model/trashDay_model.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/model/trashDayList_model.dart';
import 'package:trash_out/view/trashDayDetail_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';

final StateProvider<List> trashDaysProvider = StateProvider((ref) => []);

class TrashDayListView extends ConsumerWidget {
  const TrashDayListView({Key? key}) : super(key: key);
  // final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ref) {
    final TrashDayListModel trashDayListModel = ref.watch(trashDayListModelProvider);
    final newTrashDay = TrashDay(
      id: uuid.v4(),
      trashType: '',
      daysOfTheWeek: {1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false},
      ordinalNumbers: {1: false, 2: false, 3: false, 4: false, 5: false},
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrashDetailView(null, newTrashDay),
                  ),
                );
              },
            ),
            ValueListenableBuilder<Box<TrashDay>>(
              valueListenable: Boxes.getTrashDays().listenable(),
              builder: (context, box, _) {
                List<TrashDay> trashDays = box.values.toList().cast<TrashDay>();
                return buildContent(trashDays, trashDayListModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent(
    List<TrashDay> trashDays,
    TrashDayListModel trashDayListModel,
  ) {
    if (trashDays.isEmpty) {
      return const Center(child: Text('データがありません'));
    } else {
      return Expanded(
        child: SlidableAutoCloseBehavior(
          child: ListView.builder(
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: trashDays.length,
            itemBuilder: (BuildContext context, index) {
              final trashDay = trashDays[index];

              return buildSlidableListTile(context, trashDays, trashDay, trashDayListModel, index);
            },
          ),
        ),
      );
    }
  }

  Widget buildSlidableListTile(
    BuildContext context,
    List trashDays,
    TrashDay trashDay,
    TrashDayListModel trashDayListModel,
    int index,
  ) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            trashDayListModel.deleteTrashDay(trashDays, index);
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) {
              trashDayListModel.deleteTrashDay(trashDays, index);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(trashDay.trashType),
        subtitle: Text('${formatOrdinalNumber(trashDay.ordinalNumbers)}  ${formatDayOfTheWeek(trashDay.daysOfTheWeek)}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrashDetailView(index, trashDay),
            ),
          );
        },
      ),
    );
  }
}

String formatOrdinalNumber(
  Map<int, bool> ordinalNumbers,
) {
  String word = '';
  int count = 0;
  for (var i = 1; i <= ordinalNumbers.length; i++) {
    if (ordinalNumbers[i]!) {
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

String formatDayOfTheWeek(
  Map<int, bool> daysOfTheWeek,
) {
  String word = '';
  int count = 0;
  for (var i = 1; i <= daysOfTheWeek.length; i++) {
    if (daysOfTheWeek[i]!) {
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
