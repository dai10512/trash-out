import 'package:flutter/material.dart';
import 'package:trash_out/typeAdapter/trashDay.dart';
import 'package:trash_out/view/home_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:hive_flutter/hive_flutter.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
var box;

Future<void> _init() async {
  await _configureLocalTimeZone();
  await _initializeNotification();
  await _initializeDB();
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
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _initializeDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TrashDayAdapter());
  box = await Hive.openBox<TrashDay>('trashDays');
}

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
