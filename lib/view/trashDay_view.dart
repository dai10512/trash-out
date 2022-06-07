import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/model/trashDay_model.dart';

class TrashDetailView extends ConsumerWidget {
  const TrashDetailView(this.hiveKey, {Key? key}) : super(key: key);
  final dynamic hiveKey;

  @override
  Widget build(context, ref) {
    final TrashDayModel trashDayRead = ref.read(trashDayModelProvider(hiveKey));

    return Scaffold(
      appBar: AppBar(
        title: Text('aas'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  // onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _trashTypeForm(),
                      const SizedBox(height: 10),
                      _notificationDateForm(),
                      const SizedBox(height: 10),
                      _savedButton(hiveKey, trashDayRead),
                    ],
                  ),
                ),
              ],
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
        final TextEditingController controller = TextEditingController(text: trashDayRead.trashType);
        return Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ゴミの種類'),
                    const SizedBox(height: 15),
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
            const Text('週', textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trashDayWatch.weeksOfMonth.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (trashDayWatch.weeksOfMonth[index + 1]!) ? Colors.blue : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    trashDayRead.writeweeksOfMonth(index + 1);
                  },
                  child: Text(
                    '第${index + 1}週',
                    style: const TextStyle(color: Colors.white),
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
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trashDayRead.daysOfWeek.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (trashDayWatch.daysOfWeek[index + 1]!) ? Colors.blue : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    trashDayRead.writedaysOfWeek(index + 1);
                  },
                  child: Text(
                    dayOfTheWeekLabelMap[index + 1].toString(),
                    style: const TextStyle(
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

Widget _savedButton(dynamic hiveKey, TrashDayModel trashDayRead) {
  return Consumer(
    builder: (context, ref, child) {
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
          child: Text((hiveKey == null) ? '新規登録する' : '更新する'),
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
