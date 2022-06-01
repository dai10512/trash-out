import 'package:flutter/material.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/model/trashDayList_model.dart';
import 'package:trash_out/model/trashDay_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Uuid uuid = Uuid();

class TrashDetailView extends ConsumerWidget {
  const TrashDetailView(this.index, this.trashDay, {Key? key}) : super(key: key);
  final int? index;
  final TrashDay trashDay;

  @override
  Widget build(context, ref) {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final TrashDayModel trashDayRead = ref.read(trashDayModelProvider);
    trashDayRead.loadData(trashDay);

    return Scaffold(
      // key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Page Title',
        ),
        centerTitle: true,
        // elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _trashTypeForm(),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: const Color(0xFFF5F5F5),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ordinalNumberCheck(),
                          const SizedBox(width: 20),
                          _dayOfTheWeekCheck(),
                        ],
                      ),
                    ),
                  ),
                  _finishButton(context, index, trashDayRead),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _trashTypeForm() {
  return Consumer(
    builder: (context, ref, _) {
      final TrashDayModel trashDayRead = ref.read(trashDayModelProvider);
      final controller = TextEditingController(text: trashDayRead.trashType);

      return Column(
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: const Color(0xFFF5F5F5),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ゴミの種類'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    obscureText: false,
                    decoration: const InputDecoration(hintText: '[例：燃えるゴミ]', filled: true),
                    onChanged: (text) {
                      trashDayRead.updateTrashType(text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _ordinalNumberCheck() {
  return Consumer(
    builder: (context, ref, _) {
      final TrashDayModel trashDayRead = ref.read(trashDayModelProvider);
      final TrashDayModel trashDayWatch = ref.read(trashDayModelProvider);

      return Expanded(
        flex: 2,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '第◯番目',
              textAlign: TextAlign.center,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trashDayRead.ordinalNumbers.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (trashDayWatch.daysOfTheWeek[index + 1]!) ? Colors.blue : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    trashDayRead.updateDaysOfTheWeek(index + 1);
                    print(trashDayRead.daysOfTheWeek[index + 1]);
                  },
                  child: Text('第${index + 1}'),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _dayOfTheWeekCheck() {
  return Consumer(
    builder: (context, ref, _) {
      final TrashDayModel trashDayRead = ref.read(trashDayModelProvider);
      final TrashDayModel trashDayWatch = ref.read(trashDayModelProvider);
      return Expanded(
        flex: 3,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '曜日',
              textAlign: TextAlign.center,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trashDayRead.daysOfTheWeek.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (trashDayWatch.daysOfTheWeek[index + 1]!) ? Colors.blue : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    trashDayRead.updateDaysOfTheWeek(index + 1);
                    print(trashDayRead.daysOfTheWeek[index + 1]);
                  },
                  child: Text(dayOfTheWeekLabelMap[index + 1].toString()),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _finishButton(
  BuildContext context,
  int? index,
  TrashDayModel trashDayRead,
) {
  return Consumer(builder: (context, ref, child) {
    final trashDayListModel = ref.read(trashDayListModelProvider);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.orange,
          onPrimary: Colors.white,
        ),
        onPressed: () async {
          if (index == null) {
            trashDayListModel.addTrashDay(trashDayRead);
            Navigator.pop(context);
          } else {
            trashDayListModel.updateTrashDay(index, trashDayRead);
            Navigator.pop(context);
          }
        },
        child: const Text('保存する'),
      ),
    );
  });
}

final dayOfTheWeekLabelMap = {
  1: '月曜日',
  2: '火曜日',
  3: '水曜日',
  4: '木曜日',
  5: '金曜日',
  6: '土曜日',
  7: '日曜日',
};
