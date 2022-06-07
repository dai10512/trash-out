import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trash_out/model/trashNotification.dart';
import 'package:trash_out/repository/notificationSettings_boxRepository.dart';
import 'package:trash_out/typeAdapter/notificationSetting.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/view/home_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // newMethod(context);
    // createScaffoldMessengerStreamListen(context);

    return MaterialApp(
      theme: ThemeData(
        iconTheme: const IconThemeData.fallback().copyWith(color: Colors.grey[700]),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

Future<void> _init() async {
  await _configureLocalTimeZone();
  // await _initializeNotification();
  await _initializeAwesomeNotification();
  await _initializeDB();
  trashNotification.setNotifications();
}

_initializeAwesomeNotification() {
  AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
        NotificationChannel(
          channelGroupKey: 'scheduled_channel',
          channelKey: 'scheduled_channel',
          channelName: 'schedule notifications',
          channelDescription: 'Notification channel for schedule tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      channelGroups: [NotificationChannelGroup(channelGroupkey: 'basic_channel_group', channelGroupName: 'Basic group')],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then(
    (isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    },
  );
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> _initializeDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(TrashDayAdapter());
  Hive.registerAdapter(NotificationSettingAdapter());
  await Hive.openBox<TrashDay>('TrashDay');
  await Hive.openBox<NotificationSetting>('NotificationSetting');
  notificationSettingsBoxRepository.isFirst();
}

void newMethod(BuildContext context) {
  AwesomeNotifications().actionStream.listen(
    (ReceivedNotification receivedNotification) {
      var id;
      Navigator.of(context).pushNamed(
        '/NotificationPage',
        arguments: {
          // your page params. I recommend you to pass the
          // entire *receivedNotification* object
          id: receivedNotification.id
        },
      );
    },
  );
}

// void createScaffoldMessengerStreamListen(BuildContext context) {
//   AwesomeNotifications().createdStream.listen(
//     (notification) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Notification Created on ${notification.channelKey}'),
//       ));
//     },
//   );
// }

