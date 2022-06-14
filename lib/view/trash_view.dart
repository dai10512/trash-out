import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/modelAndController/trashOfDay_model.dart';
import 'package:trash_out/modelAndController/trash_model.dart';
import 'package:trash_out/util/util.dart';

class TrashDetailView extends ConsumerWidget {
  const TrashDetailView(this.hiveKey, {Key? key}) : super(key: key);
  final dynamic hiveKey;

  @override
  Widget build(context, ref) {
    final TrashModel trashRead = ref.read(trashModelProvider(hiveKey));

    return Scaffold(
      appBar: AppBar(
        title: const Text('登録'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  trashTypeForm(),
                  const SizedBox(height: 10),
                  notificationDateForm(),
                  const SizedBox(height: 10),
                  savedButton(hiveKey, trashRead),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget trashTypeForm() {
    return Consumer(
      builder: (context, ref, _) {
        final TrashModel trashRead = ref.read(trashModelProvider(hiveKey));
        final TextEditingController controller = TextEditingController(text: trashRead.trashType);
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
                        trashRead.writeTrashType(text);
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

  Widget notificationDateForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            weekOfMonthCheck(hiveKey),
            const SizedBox(width: 20),
            dayOfTheWeekCheck(hiveKey),
          ],
        ),
      ),
    );
  }

  Widget weekOfMonthCheck(dynamic hiveKey) {
    return Consumer(
      builder: (context, ref, _) {
        final TrashModel trashRead = ref.read(trashModelProvider(hiveKey));
        final TrashModel trashWatch = ref.watch(trashModelProvider(hiveKey));

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
                itemCount: trashWatch.weeksOfMonth.length,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        (trashWatch.weeksOfMonth[index + 1]!) ? Colors.blue : Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      trashRead.writeWeeksOfMonth(index + 1);
                    },
                    child: Text(
                      '毎月第${index + 1}',
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

  Widget dayOfTheWeekCheck(dynamic hiveKey) {
    return Consumer(
      builder: (context, ref, _) {
        final TrashModel trashRead = ref.read(trashModelProvider(hiveKey));
        final TrashModel trashWatch = ref.watch(trashModelProvider(hiveKey));
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
                itemCount: trashRead.daysOfWeek.length,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        (trashWatch.daysOfWeek[index + 1]!) ? Colors.blue : Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      trashRead.writeDaysOfWeek(index + 1);
                    },
                    child: Text(
                      weekdayMap[index + 1].toString(),
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

  Widget savedButton(dynamic hiveKey, TrashModel trashRead) {
    return Consumer(
      builder: (context, ref, child) {
        final TrashOfDayViewModel trashOfDayViewModelRead = ref.read(trashOfDayViewModelProvider);
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              await trashRead.saveTrash(hiveKey, trashRead);
              await trashOfDayViewModelRead.setTotalTrashType().then((value) => print(trashOfDayViewModelRead.totalTrashTypeOfToday));
              Navigator.pop(context);
            },
            child: Text((hiveKey == null) ? '新規登録する' : '更新する'),
          ),
        );
      },
    );
  }
}
