import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_out/state/notificationSetting_stateController.dart';
import 'package:trash_out/widget/util.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationSettingView extends ConsumerWidget {
  const NotificationSettingView({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final sendNotificationOnTheDay = ref.watch(sendNotificationOnTheDayProvider.state);
    final sendNotificationTheDayBefore = ref.watch(sendNotificationTheDayBeforeProvider.state);

    final timeOnTheDay = ref.watch(timeOnTheDayProvider.state);
    final timeTheDayBefore = ref.watch(timeTheDayBeforeProvider.state);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            const ListTile(title: Text('当日の通知 ID:0')),
            NotificationSwitchListTile(
              minusDay: 0,
              timeState: timeOnTheDay,
              sendNotification: sendNotificationOnTheDay,
            ),
            const Divider(),
            const ListTile(title: Text('前日の通知 ID:1')),
            NotificationSwitchListTile(
              minusDay: 1,
              timeState: timeTheDayBefore,
              sendNotification: sendNotificationTheDayBefore,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSwitchListTile extends StatelessWidget {
  const NotificationSwitchListTile({
    Key? key,
    required this.minusDay,
    required this.timeState,
    required this.sendNotification,
  }) : super(key: key);

  final int minusDay;
  final StateController<TimeOfDay> timeState;
  final StateController<bool> sendNotification;

  @override
  Widget build(BuildContext context) {
    final int hour = timeState.state.hour;
    final minute = timeState.state.minute;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          MaterialButton(
            child: Text(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: (sendNotification.state) ? Theme.of(context).primaryColor : Colors.grey,
              ),
              formatTime(timeState.state),
            ),
            onPressed: () async => await selectTime(context, minusDay, timeState, sendNotification),
          ),
          Switch(
            value: sendNotification.state,
            onChanged: (bool newValue) {
              sendNotification.state = newValue;
              if (sendNotification.state) {
                scheduleDailyTimeNotification(minusDay, hour, minute);
              } else {
                cancelNotification(minusDay);
              }
            },
          ),
        ],
      ),
    );
  }
}
