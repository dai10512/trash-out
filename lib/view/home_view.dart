import 'package:flutter/material.dart';
import 'package:trash_out/view/trashDays_view.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TrashDayListView(),
    );
  }
}
