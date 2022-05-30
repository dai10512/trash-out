import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:trash_out/main.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/typeAdapter/trashDayList_model.dart';
import 'package:trash_out/typeAdapter/trashDay_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Uuid uuid = Uuid();

class TrashDetailView extends ConsumerWidget {
  const TrashDetailView(this.trashDay, {Key? key}) : super(key: key);
  final TrashDay? trashDay;

  @override
  Widget build(context, ref) {
    // final trashDayModelProvider = ChangeNotifierProvider<TrashDayModel>((ref,trashDay) => TrashDayModel(trashDay));
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final TrashDayListModel trashDayListModel = ref.read(trashDayListModelProvider);
    // final TrashDayModel trashDayModel = ref.read(trashDayModel);
    final TextEditingController trashTypeController = TextEditingController(text: trashDay?.trashType);

    // final Map<int, bool> ordinalNumberMap = getOrdinalNumberMap(trashDay?.ordinalNumbers);

    final Map<int, Map<String, dynamic>> dayOfTheWeekMap = getDayOfTheWeekMap(trashDay?.daysOfTheWeek);
    final StateProvider<Map<int, Map<String, dynamic>>> dayOfTheWeekProvider = StateProvider((ref) => dayOfTheWeekMap);

    print(trashDay);

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
                  _trashTypeForm(trashTypeController),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: const Color(0xFFF5F5F5),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // _ordinalNumberCheck(ordinalNumberMap),
                          // _dayOfTheWeekCheck(context, dayOfTheWeekMap),
                          _dayOfTheWeekCheckList(context, dayOfTheWeekMap),
                        ],
                      ),
                    ),
                  ),
                  _finishButton(context, trashDay, trashDayListModel, trashTypeController.text, [1, 2], [1, 2, 3]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _spacer() {
  return Container(
    width: double.infinity,
    height: 20,
    decoration: const BoxDecoration(),
  );
}

Widget _trashTypeForm(TextEditingController trashTypeController) {
  bool isValue = false;

  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    color: const Color(0xFFF5F5F5),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
      // padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ゴミの種類'),
          Container(
            width: double.infinity,
            height: 10,
          ),
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
  );
}

// Widget _ordinalNumberCheck(ordinalNumberMap) {
//   print(ordinalNumberMap);
//   return Expanded(
//     flex: 2,
//     child: Column(
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           '第◯番目',
//           textAlign: TextAlign.center,
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: ordinalNumberMap.length,
//           itemBuilder: (BuildContext context, int index) {
//             int _key = ordinalNumberMap.keys.elementAt(index);
//             bool _value = ordinalNumberMap[_key];

//             return CheckboxListTile(
//               value: _value,
//               onChanged: (_value) {
//                 print('checked1');

//                 _value = _value!;
//                 print('checked2');
//                 print(_value);
//               },
//               title: Text('第${_key}'),
//             );
//           },
//         ),
//       ],
//     ),
//   );
// }

Widget _dayOfTheWeekCheck(context, dayOfTheWeekMap) {
  final StateProvider dayOfTheWeekProvider = StateProvider(((ref) => dayOfTheWeekMap));

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
          itemCount: dayOfTheWeekMap.length,
          itemBuilder: (BuildContext context, int index) {
            int key = dayOfTheWeekMap.keys.elementAt(index);
            Map map = dayOfTheWeekMap[key];
            bool value = map['doNotify'];
            return ElevatedButton(
              child: Text(map['label']),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  (value) ? Colors.blue : Colors.grey,
                ),
              ),
              onPressed: () {
                print(value);
                value = !value;
                print(value);
              },
            );
            // return CheckboxListTile(
            //   value: value,
            //   onChanged: (bool? newValue) {
            //     print('checked1');
            //     print(value);

            //     value = newValue!;
            //     print('checked2');
            //     print(value);
            //   },
            //   title: Text(key),
            // );
          },
        ),
      ],
    ),
  );
}

Widget _dayOfTheWeekCheckList(context, dayOfTheWeekMap) {
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
          itemCount: dayOfTheWeekMap.length,
          itemBuilder: (BuildContext context, int index) {
            int key = dayOfTheWeekMap.keys.elementAt(index);
            Map map = dayOfTheWeekMap[key];
            bool value = map['doNotify'];
            return ElevatedButton(
              child: Text(map['label']),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  (value) ? Colors.blue : Colors.grey,
                ),
              ),
              onPressed: () {
                print(value);
                value = !value;
                print(value);
              },
            );
            // return CheckboxListTile(
            //   value: value,
            //   onChanged: (bool? newValue) {
            //     print('checked1');
            //     print(value);

            //     value = newValue!;
            //     print('checked2');
            //     print(value);
            //   },
            //   title: Text(key),
            // );
          },
        ),
      ],
    ),
  );
}

Widget _finishButton(context, trashDay, TrashDayListModel trashDayListModel, trashTypeText, daysOfTheWeek, ordinalNumbers) {
  return Container(
    width: double.infinity,
    child: ElevatedButton(
      child: const Text('保存する'),
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        onPrimary: Colors.white,
      ),
      onPressed: () async {
        // trashDayListModel.addTrashDay(uuid.v4(), trashTypeText, [1], [1]);
        trashDayListModel.addTrashDay(uuid.v4(), trashDay, [1], [1]);
        print("taped");
        Navigator.pop(context);
      },
    ),
  );
}

Map<int, Map<String, dynamic>> getDayOfTheWeekMap(List? dayOfTheWeek) {
  final Map<int, Map<String, dynamic>> dayOfTheWeekMap = {
    1: {'label': '月曜日', 'doNotify': false},
    2: {'label': '火曜日', 'doNotify': false},
    3: {'label': '水曜日', 'doNotify': false},
    4: {'label': '木曜日', 'doNotify': false},
    5: {'label': '金曜日', 'doNotify': false},
    6: {'label': '土曜日', 'doNotify': false},
    7: {'label': '日曜日', 'doNotify': false},
  };

  if (dayOfTheWeek != null) {
    print(dayOfTheWeek);
  }

  return dayOfTheWeekMap;
}

Map<int, bool> getOrdinalNumberMap(List? ordinalNumbers) {
  final Map<int, bool> ordinalNumberMap = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
  };

  if (ordinalNumbers != null) {
    ordinalNumbers.forEach((item) {
      print(item);
    });
  }

  return ordinalNumberMap;
}
