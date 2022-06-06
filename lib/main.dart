import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trash_out/localNotification.dart';
import 'package:trash_out/repository/trashDayNotifications_boxRepository.dart';
import 'package:trash_out/typeAdapter/trashDayNotification.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/view/home_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

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
    return MaterialApp(
      theme: ThemeData(
        iconTheme: const IconThemeData.fallback().copyWith(color: Colors.grey[700]),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

Future<void> _init() async {
  await _configureLocalTimeZone();
  await _initializeNotification();
  await _initializeDB();
  localNotification.setNotifications();
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> _initializeNotification() async {
  const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _initializeDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(TrashDayAdapter());
  Hive.registerAdapter(TrashDayNotificationAdapter());
  await Hive.openBox<TrashDay>('trashDays');
  await Hive.openBox<TrashDayNotification>('notifications');
  trashDayNotificationsBoxRepository.isFirst();
}
