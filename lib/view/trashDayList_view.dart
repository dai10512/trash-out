import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/typeAdapter/trashDay_model.dart';
import 'package:trash_out/view/trashDayDetail_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';

final StateProvider<List> trashDaysProvider = StateProvider((ref) => []);
// final StateProvider<String> trashDayIdProvider = StateProvider((ref) => '');
// final StateProvider<String> trashTypeProvider = StateProvider((ref) => '');
// final StateProvider<List<int>> daysOfWeekProvider = StateProvider((ref) => []);
// final StateProvider<List<int>> ordinalNumbersProvider = StateProvider((ref) => []);

class TrashDayListView extends ConsumerWidget {
  TrashDayListView({Key? key}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int itemCount = 2;

  @override
  Widget build(BuildContext context, ref) {
    // final List trashDayModel = ref.read(trashDaysProvider);
    final TrashDayModel trashDayModel = ref.read(trashDayModelProvider);
    final contentsController = TextEditingController();
    const uuid = Uuid();

    return GestureDetector(
      // onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Column(
          children: [
            TextField(
              controller: contentsController,
              decoration: const InputDecoration(
                hintText: 'ヒント',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => {
                trashDayModel.addTrashDay(
                  uuid.v4(),
                  contentsController.text,
                  [1],
                  [1],
                ),
                contentsController.text = '',
              },
            ),
            ValueListenableBuilder<Box<TrashDay>>(
              valueListenable: Boxes.getTrashDays().listenable(),
              builder: (context, box, _) {
                List<TrashDay> trashDays = box.values.toList().cast<TrashDay>();
                return buildContent(trashDays, trashDayModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent(List<TrashDay> trashDays, trashDayModel) {
    print(trashDays);
    if (trashDays.isEmpty) {
      return const Center(
        child: Text(
          'データがありません',
        ),
      );
    } else {
      return Expanded(
        child: SlidableAutoCloseBehavior(
          child: ListView.builder(
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: trashDays.length,
            itemBuilder: (BuildContext context, int index) {
              final trashDay = trashDays[index];
              return buildSlidableListTile(context, trashDays, trashDay, trashDayModel, index);
            },
          ),
        ),
      );
    }
  }

  Widget buildSlidableListTile(
    context,
    List trashDays,
    TrashDay trashDay,
    TrashDayModel trashDayModel,
    int index,
  ) {
    print(trashDays.length);
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            trashDayModel.deleteTrashDay(trashDay, trashDays, index);
            print(trashDays.length);

            // trashDays.moveAt(index);
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) {
              trashDayModel.deleteTrashDay(trashDay, trashDays, index);
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
        subtitle: Text('${ordinalNumberToString(trashDay.ordinalNumbers)}  ${formatDayOfTheWeek(trashDay.daysOfTheWeek)}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          print("taped");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TrashDetailView(),
            ),
          );
        },
      ),
    );
  }
}

String ordinalNumberToString(List<int> ordinalNumbers) {
  String ordinalWord = '';
  for (var i = 0; i < ordinalNumbers.length; i++) {
    ordinalWord += '第${ordinalNumbers[i]},';
  }
  return ordinalWord;
}

String formatDayOfTheWeek(List<int> dayOfTheWeek) {
  String dayOfTheWeekWord = '';
  for (var i = 0; i < dayOfTheWeek.length; i++) {
    final dayOfTheWeekInt = dayOfTheWeek[i];
    dayOfTheWeekWord = dayOfTheWeekMap[dayOfTheWeekInt]!;
    // dayOfTheWeekWord += 1.toString();
  }
  return dayOfTheWeekWord;
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
