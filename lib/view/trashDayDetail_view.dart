// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/newModel/trashDay_Model.dart';
import 'package:trash_out/newModel/trashDayList_model.dart';

class TrashDetailView extends ConsumerWidget {
  const TrashDetailView(this.hiveKey, {Key? key}) : super(key: key);
  final dynamic hiveKey;

  @override
  Widget build(context, ref) {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // final TrashDayListModel trashDayListRead = ref.read(trashDayListModelProvider);
    // final List<TrashDay> trashDays = trashDayListRead.getTrashDays();

    final TrashDayModel trashDayRead = ref.read(trashDayModelProvider(hiveKey));
    // trashDayRead.loadData(hiveKey);

    return Scaffold(
      // key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Page Title'),
        centerTitle: true,
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
                  _notificationDateForm(),
                  _savehButton(hiveKey, trashDayRead),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _trashTypeForm() {
    return Consumer(
      builder: (context, ref, _) {
        final TrashDayModel trashDayRead = ref.read(trashDayModelProvider(hiveKey));
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
                        print(text);
                        trashDayRead.writeTrashType(text);
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

  Widget _notificationDateForm() {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: const Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ordinalNumberCheck(hiveKey),
            const SizedBox(width: 20),
            _dayOfTheWeekCheck(hiveKey),
          ],
        ),
      ),
    );
  }
}

Widget _ordinalNumberCheck(dynamic hiveKey) {
  return Consumer(
    builder: (context, ref, _) {
      final TrashDayModel trashDayRead = ref.read(trashDayModelProvider(hiveKey));
      final TrashDayModel trashDayWatch = ref.watch(trashDayModelProvider(hiveKey));

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
              itemCount: trashDayWatch.ordinalNumbers.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (trashDayWatch.ordinalNumbers[index + 1]!) ? Colors.blue : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    trashDayRead.writeOrdinalNumbers(index + 1);
                  },
                  child: Text(
                    '第${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _dayOfTheWeekCheck(dynamic hiveKey) {
  return Consumer(
    builder: (context, ref, _) {
      final TrashDayModel trashDayRead = ref.read(trashDayModelProvider(hiveKey));
      final TrashDayModel trashDayWatch = ref.watch(trashDayModelProvider(hiveKey));
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
                    trashDayRead.writeDaysOfTheWeek(index + 1);
                  },
                  child: Text(
                    dayOfTheWeekLabelMap[index + 1].toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _savehButton(dynamic hiveKey, TrashDayModel trashDayRead) {
  return Consumer(
    builder: (context, ref, child) {
      final trashDayListModel = ref.read(trashDayListModelProvider);
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            onPrimary: Colors.white,
          ),
          onPressed: () async {
            trashDayRead.saveTrashDay(hiveKey, trashDayRead);
            Navigator.pop(context);
          },
          child: const Text('保存する'),
        ),
      );
    },
  );
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
