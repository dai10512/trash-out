
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/model/TRashDayNotifications_model.dart';
import 'package:trash_out/model/trashDayNotification_model.dart';
import 'package:trash_out/repository/trashDayNotifications_boxRepository.dart';

class NotificationSettingView extends ConsumerWidget {
  const NotificationSettingView({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final TrashDayNotificationsModel trashDaysNotificationsModelRead = ref.read(trashDayNotificationsModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ValueListenableBuilder<Box<dynamic>>(
                valueListenable: trashDayNotificationsBoxRepository.box.listenable(),
                builder: (context, box, _) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: trashDaysNotificationsModelRead.trashDayNotifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      return notificationListTile(context, index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget notificationListTile(BuildContext context, int index) {
  return Consumer(
    builder: (context, ref, _) {
      final TrashDayNotificationModel trashDayNotificationModelRead = ref.read(trashDayNotificationModelProvider(index));
      final TrashDayNotificationModel trashDayNotificationModelWatch = ref.watch(trashDayNotificationModelProvider(index));
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${formatWhichDay(trashDayNotificationModelWatch.whichDay)}のゴミ出しの通知時間',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: (trashDayNotificationModelRead.doNotify) ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      child: Text(
                        trashDayNotificationModelWatch.formatTime(trashDayNotificationModelWatch.time),
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                              color: (trashDayNotificationModelRead.doNotify) ? Theme.of(context).primaryColor : Colors.grey,
                            ),
                      ),
                      onPressed: () async => await trashDayNotificationModelRead.writeTime(context, index, trashDayNotificationModelRead.time),
                    ),
                    Switch(
                      value: trashDayNotificationModelWatch.doNotify,
                      onChanged: (value) {
                        trashDayNotificationModelRead.writeDoNotify(index);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

String formatWhichDay(int whichDay) {
  String text = '';
  if (whichDay == 0) {
    text = '今日';
  } else {
    text = '明日';
  }
  return text;
}
