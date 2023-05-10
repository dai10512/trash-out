import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../modelAndController/notificationSetting_model.dart';
import '../repository/notificationSettings_boxRepository.dart';
import '../typeAdapter/notificationSetting.dart';
import '../util/util.dart';

class NotificationSettingView extends ConsumerWidget {
  const NotificationSettingView({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ValueListenableBuilder<Box<dynamic>>(
                valueListenable:
                    notificationSettingsBoxRepository.box.listenable(),
                builder: (context, box, _) {
                  List<NotificationSetting> notificationSettings =
                      box.values.toList().cast<NotificationSetting>();

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
          ],
        ),
      ),
    );
  }
}

Widget notificationListTile(BuildContext context, int index) {
  return Consumer(
    builder: (context, ref, _) {
      final NotificationSettingModel notificationSettingModelRead =
          ref.read(notificationSettingModelProvider(index));
      final NotificationSettingModel notificationSettingModelWatch =
          ref.watch(notificationSettingModelProvider(index));
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Card(
          elevation: commonElevation,
          child: Container(
            decoration: BoxDecoration(
                gradient: (notificationSettingModelRead.doNotify)
                    ? cardGradient
                    : cardGradientOff,
                borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  '当日の収集ゴミの通知時間',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: (notificationSettingModelRead.doNotify)
                            ? cardTextColor
                            : cardTextColorOff,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                        child: Text(
                          notificationSettingModelWatch
                              .formatTime(notificationSettingModelWatch.time),
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                color: (notificationSettingModelRead.doNotify)
                                    ? cardTextColor
                                    : cardTextColorOff,
                              ),
                        ),
                        onPressed: () async {
                          await notificationSettingModelRead.writeTime(context,
                              index, notificationSettingModelRead.time);
                        }),
                    Switch(
                      value: notificationSettingModelWatch.doNotify,
                      onChanged: (value) async {
                        await notificationSettingModelRead.writeDoNotify(index);
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
