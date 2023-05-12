import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/model/trash_info.dart';
import 'package:trash_out/model/trash_info_list_service.dart';
import 'package:uuid/uuid.dart';

import '../util/util.dart';

class TrashDetailView extends ConsumerStatefulWidget {
  const TrashDetailView(this.trashInfo, {super.key});
  final TrashInfo? trashInfo;

  @override
  ConsumerState<TrashDetailView> createState() => _TrashDetailViewState();
}

class _TrashDetailViewState extends ConsumerState<TrashDetailView> {
  TrashInfoListService get trashListServiceNotifier =>
      ref.watch(trashInfoListServiceProvider.notifier);

  TextEditingController trashTypeController = TextEditingController(text: '');
  Map<int, bool> daysOfWeek = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false
  };
  Map<int, bool> weeksOfMonth = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
  };

  @override
  void initState() {
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
                savedButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget trashTypeForm() {
    return Column(
      children: [
        Card(
          elevation: commonElevation,
          child: Container(
            decoration: BoxDecoration(
                gradient: cardGradientOff,
                borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsetsDirectional.all(15),
            child: Column(
              children: [
                const Text('ゴミの種類'),
                const SizedBox(height: 15),
                TextFormField(
                  controller: trashTypeController,
                  autofocus: true,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: '[例：燃えるゴミ]',
                    filled: true,
                  ),
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
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsetsDirectional.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            weekOfMonthButtons(),
            const SizedBox(width: 20),
            dayOfTheWeekButtons(),
          ],
        ),
      ),
    );
  }

  Widget weekOfMonthButtons() {
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
            itemCount: weeksOfMonth.length,
            itemBuilder: (context, index) {
              bool isSelectedWeekOfMonth = weeksOfMonth[index + 1]!;
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    isSelectedWeekOfMonth
                        ? Colors.blue // 選択時
                        : Colors.grey, // 非選択時
                  ),
                ),
                onPressed: () {
                  weeksOfMonth[index + 1] = !isSelectedWeekOfMonth;
                  setState(() {});
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

  Widget dayOfTheWeekButtons() {
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
            itemCount: daysOfWeek.length,
            itemBuilder: (BuildContext context, int index) {
              bool isSelectedDayOfWeek = daysOfWeek[index + 1]!;

              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    isSelectedDayOfWeek ? Colors.blue : Colors.grey,
                  ),
                ),
                onPressed: () {
                  daysOfWeek[index + 1] = !isSelectedDayOfWeek;
                  setState(() {});
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

  Widget savedButton() {
    // final trashOfDayViewModelRead = ref.read(trashOfDayViewModelProvider);
    // final trashRead = ref.read(trashModelProvider(hiveKey));

    return ElevatedButton(
      onPressed: () async {
        //validation設ける
        final newTrashInfo = TrashInfo(
          id: const Uuid().v4(),
          trashType: trashTypeController.text,
          weeksOfMonth: weeksOfMonth,
          daysOfWeek: daysOfWeek,
        );
        await trashListServiceNotifier.add(newTrashInfo);
        ref.invalidate(trashInfoListServiceProvider);
        // sharedに保存する
        // await trashRead.saveTrash(hiveKey, trashRead);
        // await trashOfDayViewModelRead.setTotalTrashType();
        if (mounted) {
          Navigator.pop(context);
        }
      },
      // elevation: commonElevation,
      // padding: EdgeInsets.zero,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Center(
        child: Text(widget.trashInfo == null ? '新規登録する' : '更新する'),
      ),
    );
  }
}
