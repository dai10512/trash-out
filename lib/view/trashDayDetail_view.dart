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
                          // _ordinalNumberCheck(ordinalNumberMap),
                          // _dayOfTheWeekCheck(trashType),
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

Widget _spacer() {
  return Container(
    width: double.infinity,
    height: 20,
    decoration: const BoxDecoration(),
  );
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

Widget _dayOfTheWeekCheck() {
  return Consumer(builder: (context, ref, _) {
    final TrashDayModel trashDayRead = ref.read(trashDayModelProvider);
    final daysOfTheWeekMap = getDaysOfTheWeekMap(trashDayRead.daysOfTheWeek);

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
            itemCount: daysOfTheWeekMap.length,
            itemBuilder: (BuildContext context, int index) {
              // int key = ;
              // Map map = dayOfTheWeekMap[key];
              // bool value = map['doNotify'];
              return ElevatedButton(
                // child: Text('label'),
                child: Text(daysOfTheWeekMap[index + 1]!['label']),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    (daysOfTheWeekMap[index + 1]!['doNotify']) ? Colors.blue : Colors.grey,
                  ),
                ),
                onPressed: () {
                  print(index);
                  print(daysOfTheWeekMap[index + 1]!['doNotify']);
                },
              );
            },
          ),
        ],
      ),
    );
  });
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
        child: const Text('保存する'),
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
      ),
    );
  });
}

Map<int, Map<String, dynamic>> getDaysOfTheWeekMap(List daysOfTheWeek) {
  final Map<int, Map<String, dynamic>> daysOfTheWeekMap = {
    1: {'label': '月曜日', 'doNotify': false},
    2: {'label': '火曜日', 'doNotify': false},
    3: {'label': '水曜日', 'doNotify': false},
    4: {'label': '木曜日', 'doNotify': false},
    5: {'label': '金曜日', 'doNotify': false},
    6: {'label': '土曜日', 'doNotify': false},
    7: {'label': '日曜日', 'doNotify': false},
  };

  for (var i = 0; i < daysOfTheWeek.length; i++) {
    if (daysOfTheWeekMap.containsKey(daysOfTheWeek[i])) {
      daysOfTheWeekMap[daysOfTheWeek[i]]!['doNotify'] == true;
    }
  }
  print(daysOfTheWeekMap);

  return daysOfTheWeekMap;
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
