import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/modelAndController/trashOfDay_model.dart';
import 'package:trash_out/modelAndController/trash_model.dart';
import 'package:trash_out/repository/trashList_boxRepository.dart';
import 'package:trash_out/typeAdapter/trash.dart';
import 'package:trash_out/util/util.dart';
import 'package:trash_out/view/trashList_view.dart';
import 'package:trash_out/view/notificationSetting_view.dart';
import 'package:trash_out/view/trash_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final List<Widget> appBarIconList = [
      IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.list),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TrashListView()));
        },
      ),
      IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingView()));
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        centerTitle: true,
        actions: appBarIconList,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: commonHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            buildHeadline('今日の収集ゴミ'),
            buildTrashOfDayCard(context, 0),
            const SizedBox(height: 30),
            buildHeadline('明日の収集ゴミ'),
            buildTrashOfDayCard(context, 1),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildHeadline(text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget buildTrashOfDayCard(BuildContext context, int whichDay) {
    return Consumer(
      builder: (context, ref, _) {
        final TrashOfDayViewModel trashOfDayViewModelWatch = ref.watch(trashOfDayViewModelProvider); //必要
        return Expanded(
          child: Card(
            elevation: commonElevation,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(gradient: cardGradient, borderRadius: BorderRadius.circular(10.0)),
              width: double.infinity,
              // padding: const EdgeInsets.all(13.0),
              child: StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        FutureBuilder(
                          future:
                              (whichDay == 0) ? trashOfDayViewModelWatch.getTotalTrashTypeOfToday() : trashOfDayViewModelWatch.getTotalTrashTypeOfTomorrow(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print(now.day / 7);
                              return Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.zero,
                                    width: double.infinity,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          (whichDay == 0)
                                              ? '$today\n${formatWeekOfMonthMap[(now.day / 7).toInt() + 1]}週 ${formatWeekdayMap[now.weekday]}'
                                              : '$tomorrow\n${formatWeekOfMonthMap[(after24h.day / 7).toInt() + 1]}週 ${formatWeekdayMap[after24h.weekday]}',
                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: cardTextColor),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: FittedBox(
                                        child: Text(
                                          snapshot.data.toString(),
                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: cardTextColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return FittedBox(
                                child: Text(
                                  "無し",
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.blueGrey[700]),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
