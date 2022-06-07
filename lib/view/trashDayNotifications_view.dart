import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trash_out/model/trashNotification.dart';
import 'package:trash_out/model/NotificationSetting_model.dart';
import 'package:trash_out/repository/notificationSettings_boxRepository.dart';
import 'package:trash_out/typeAdapter/notificationSetting.dart';

class NotificationSettingView extends ConsumerWidget {
  const NotificationSettingView({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ValueListenableBuilder<Box<dynamic>>(
                valueListenable: notificationSettingsBoxRepository.box.listenable(),
                builder: (context, box, _) {
                  List<NotificationSetting> notificationSettings = box.values.toList().cast<NotificationSetting>();

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notificationSettings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return notificationListTile(context, index);
                    },
                  );
                },
              ),
            ),
            TextButton(
              child: Text('cancel'),
              onPressed: () async {
                trashNotification.cancelAllNotifications();
              },
            ),
            TextButton(
              child: Text('awesomeNotificaion'),
              onPressed: () async {
                trashNotification.judgeSetNotification();
              },
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
      final NotificationSettingModel notificationSettingModelRead = ref.read(notificationSettingModelProvider(index));
      final NotificationSettingModel notificationSettingModelWatch = ref.watch(notificationSettingModelProvider(index));
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${formatWhichDay(notificationSettingModelWatch.whichDay)}のゴミ出しの通知時間',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: (notificationSettingModelRead.doNotify) ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      child: Text(
                        notificationSettingModelWatch.formatTime(notificationSettingModelWatch.time),
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                              color: (notificationSettingModelRead.doNotify) ? Theme.of(context).primaryColor : Colors.grey,
                            ),
                      ),
                      onPressed: () async => await notificationSettingModelRead.writeTime(context, index, notificationSettingModelRead.time),
                    ),
                    Switch(
                      value: notificationSettingModelWatch.doNotify,
                      onChanged: (value) async {
                        await trashNotification.requestPermissions();
                        notificationSettingModelRead.writeDoNotify(index);
                        await trashNotification.cancelAllNotifications();
                        trashNotification.judgeSetNotification();
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
