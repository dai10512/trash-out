import 'package:flutter/material.dart';
import 'package:trash_out/view/trash_list_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _actionStream(BuildContext context) {
    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: (ReceivedAction receivedAction) async {
    //     // NotificationController.onActionReceivedMethod(context, receivedAction);
    //   },
    // );
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _actionStream(context);
      // createScaffoldMessengerStreamListen(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ja'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme:
            const IconThemeData.fallback().copyWith(color: Colors.grey[700]),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const TrashListView(),
    );
  }
}
