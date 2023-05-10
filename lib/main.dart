import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import 'modelAndController/trashOfDayNotification_controller.dart';
import 'my_app.dart';
import 'repository/notificationSettings_boxRepository.dart';
import 'typeAdapter/notificationSetting.dart';
import 'typeAdapter/trash.dart';
import 'typeAdapter/trashOfDay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
Future<void> _init() async {
  await _initializeAwesomeNotification();
  await _initializeDB();
  await trashNotificationController.setNotifications();
}



Future<void> _initializeAwesomeNotification() async {
  // AwesomeNotifications().initialize(
  //   'resource://drawable/res_app_icon',
  //   [
  //     NotificationChannel(
  //       channelGroupKey: 'basic_channel_group',
  //       channelKey: 'TrashOut',
  //       channelName: 'TrashOut',
  //       channelDescription: 'scheduledNotification',
  //     ),
  //   ],
  //   channelGroups: [
  //     NotificationChannelGroup(
  //         channelGroupKey: 'basic_channel_group',
  //         channelGroupName: 'Basic group'),
  //   ],
  //   debug: true,
  // );

  // AwesomeNotifications().isNotificationAllowed().then(
  //   (isAllowed) {
  //     if (!isAllowed) {
  //       AwesomeNotifications().requestPermissionToSendNotifications();
  //     }
  //   },
  // );
}

Future<void> _initializeDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(TrashAdapter());
  Hive.registerAdapter(NotificationSettingAdapter());
  Hive.registerAdapter(TrashOfDayAdapter());
  await Hive.openBox<Trash>('Trash');
  await Hive.openBox<NotificationSetting>('NotificationSetting');
  await Hive.openBox<TrashOfDay>('TrashOfDay');
  notificationSettingsBoxRepository.isFirst();
}

// // versionが古いため修正
// void _actionStream(BuildContext context) {
//   AwesomeNotifications().actionStream.listen(
//     (ReceivedNotification receivedNotification) {
//       var id;
//       Navigator.of(context).pushNamed(
//         '/NotificationPage',
//         arguments: {
//           // your page params. I recommend you to pass the
//           // entire *receivedNotification* object
//           id: receivedNotification.id
//         },
//       );
//     },
//   );
// }

 actionStream(BuildContext context) {
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (ReceivedAction receivedAction) async {
      // NotificationController.onActionReceivedMethod(context, receivedAction);
    },
  );
}


// 使用してなさそう
// void createScaffoldMessengerStreamListen(BuildContext context) {
//   AwesomeNotifications().createdStream.listen(
//     (notification) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Notification Created on ${notification.channelKey}'),
//       ));
//     },
//   );
// }

