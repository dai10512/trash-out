import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/model/trash_info.dart';

import '../modelAndController/trashOfDay_model.dart';
import '../modelAndController/trash_model.dart';
import '../util/util.dart';

class TrashDetailView extends ConsumerStatefulWidget {
  const TrashDetailView(this.hiveKey, {super.key});
  final dynamic hiveKey;

  @override
  ConsumerState<TrashDetailView> createState() => _TrashDetailViewState();
}

class _TrashDetailViewState extends ConsumerState<TrashDetailView> {
  get hiveKey => widget.hiveKey;
  final newTrashInfo = const TrashInfo();

  TextEditingController trashTypeController = TextEditingController(text: '');
  Map<int, bool> weeksOfMonth = {};
  Map<int, bool> daysOfWeek = {};

  @override
  void initState() {
    trashTypeController.text = newTrashInfo.trashType;
    weeksOfMonth = newTrashInfo.weeksOfMonth;
    daysOfWeek = newTrashInfo.daysOfWeek;
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                trashTypeForm(),
                const SizedBox(height: 10),
                notificationDateForm(),
                const SizedBox(height: 10),
                savedButton(hiveKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget trashTypeForm() {
    final trashRead = ref.read(trashModelProvider(hiveKey));
    final controller = TextEditingController(text: trashRead.trashType);
    return Column(
      children: [
        Card(
          elevation: commonElevation,
          child: Container(
            decoration: BoxDecoration(
                gradient: cardGradientOff,
                borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
            child: Column(
              children: [
                const Text('ゴミの種類'),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  obscureText: false,
                  decoration: const InputDecoration(
                      hintText: '[例：燃えるゴミ]', filled: true),
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
  }

  Widget notificationDateForm() {
    return Card(
      elevation: commonElevation,
      child: Container(
        decoration: BoxDecoration(
            gradient: cardGradientOff,
            borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            weekOfMonthButtons(hiveKey),
            const SizedBox(width: 20),
            dayOfTheWeekButtons(hiveKey),
          ],
        ),
      ),
    );
  }

  Widget weekOfMonthButtons(dynamic hiveKey) {
    final trashWatch = ref.watch(trashModelProvider(hiveKey));
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
                    (trashWatch.weeksOfMonth[index + 1]!)
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
                onPressed: () {
                  trashWatch.writeWeeksOfMonth(index + 1);
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
  }

  Widget dayOfTheWeekButtons(dynamic hiveKey) {
    final trashWatch = ref.read(trashModelProvider(hiveKey));

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
            itemCount: trashWatch.daysOfWeek.length,
            itemBuilder: (BuildContext context, int index) {
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    (trashWatch.daysOfWeek[index + 1]!)
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
                onPressed: () {
                  trashWatch.writeDaysOfWeek(index + 1);
                },
                child: Text(
                  formatWeekdayMap[index + 1].toString(),
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
  }

  Widget savedButton(
    dynamic hiveKey,
  ) {
    final trashOfDayViewModelRead = ref.read(trashOfDayViewModelProvider);
    final trashRead = ref.read(trashModelProvider(hiveKey));

    return MaterialButton(
      onPressed: () async {
        await trashRead.saveTrash(hiveKey, trashRead);
        await trashOfDayViewModelRead.setTotalTrashType();
        Navigator.pop(context);
      },
      elevation: commonElevation,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: commonElevation,
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: buttonGradient,
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Text(hiveKey == null ? '新規登録する' : '更新する'),
          ),
        ),
      ),
    );
  }
}
