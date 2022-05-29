import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:trash_out/main.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';

class TrashDetailView extends StatefulWidget {
  const TrashDetailView({Key? key}) : super(key: key);

  @override
  _TrashDetailViewState createState() => _TrashDetailViewState();
}

class _TrashDetailViewState extends State<TrashDetailView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // On page load action.
    // SchedulerBinding.instance?.addPostFrameCallback((_) async {
    //   Navigator.pop(context);
    // });
  }

  final Map<String, bool> _dayOfTheWeekMap = {
    '月曜日': false,
    '火曜日': false,
    '水曜日': false,
    '木曜日': false,
    '金曜日': false,
    '土曜日': false,
    '日曜日': false,
  };

  final Map<String, bool> _ordinalNumberMap = {
    '1回目': false,
    '2回目': false,
    '3回目': false,
    '4回目': false,
    '5回目': false,
  };


  @override
  Widget build(BuildContext context) {
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
                  _trashType(),
                  // _spacer(),
                  // _ordinalNumberCheck(_ordinalNumberMap),
                  _spacer(),
                  _dayOfTheWeekCheck(_dayOfTheWeekMap),
                  _finishButton('燃えるゴミ', [1, 2], [1, 2, 3]),
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

Widget _trashType() {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    color: const Color(0xFFF5F5F5),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ゴミの種類',
          ),
          Container(
            width: double.infinity,
            height: 10,
          ),
          TextFormField(
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

Widget _ordinalNumberCheck(ordinalNumberMap) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    color: const Color(0xFFF5F5F5),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
      child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          '第◯番目',
          textAlign: TextAlign.center,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ordinalNumberMap.length,
          itemBuilder: (BuildContext context, int index) {
            String _key = ordinalNumberMap.keys.elementAt(index);
            bool _value = ordinalNumberMap[_key];
            return CheckboxListTile(
              value: _value,
              onChanged: (value) {
                _value = value!;
                print('checked');
              },
              title: Text(_key),
            );
          },
        ),
      ]),
    ),
  );
}

Widget _dayOfTheWeekCheck(_dayOfTheWeekMap) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    color: const Color(0xFFF5F5F5),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '曜日',
            textAlign: TextAlign.center,
          ),
          Container(
            width: double.infinity,
            height: 10,
            decoration: const BoxDecoration(),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dayOfTheWeekMap.length,
            itemBuilder: (BuildContext context, int index) {
              String _key = _dayOfTheWeekMap.keys.elementAt(index);
              bool _value = _dayOfTheWeekMap[_key];
              return CheckboxListTile(
                value: _value,
                onChanged: (_value) {
                  // _value = _value!;
                  print('checked');
                },
                title: Text(_key),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget _finishButton(trashType, daysOfTheWeek, ordinalNumbers) {
  return Container(
    width: double.infinity,
    child: ElevatedButton(
      child: const Text('Button'),
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        onPrimary: Colors.white,
      ),
      onPressed: () async {
        // create(trashType, daysOfTheWeek, ordinalNumbers);
      },
    ),
  );
}
