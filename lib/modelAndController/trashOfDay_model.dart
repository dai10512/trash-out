import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/trashOfDay_boxRepository.dart';
import '../typeAdapter/trashOfDay.dart';

TrashOfDayViewModel trashOfDayViewModel = TrashOfDayViewModel();

final trashOfDayViewModelProvider = ChangeNotifierProvider<TrashOfDayViewModel>((ref) => TrashOfDayViewModel());


final DateTime today = DateTime.now();
final DateTime tomorrow = today.add(const Duration(days: 1));

class TrashOfDayViewModel extends ChangeNotifier {
  String totalTrashTypeOfToday = 'today';
  String totalTrashTypeOfTomorrow = 'tomorrow';

  Future<void> setTotalTrashType() async {
    print('start setTotalTrashType');
    List<TrashOfDay> trashDayOfList = trashOfDayBoxRepository.getTrashOfDayList();

    final currentWeekOfMonth = (today.day ~/ 7) + 1;
    final currentWeekDay = today.weekday;

    totalTrashTypeOfToday = '無し';

    for (var i = 0; i < trashDayOfList.length; i++) {
      final trashDay = trashDayOfList[i];
      if (currentWeekOfMonth == trashDay.weekOfMonth && currentWeekDay == trashDay.weekday) {
        totalTrashTypeOfToday = trashDay.totalTrashType;
        print('今日のゴミ:$totalTrashTypeOfToday');
        break;
      }
    }

    final tomorrowWeekOfMonth = (tomorrow.day ~/ 7) + 1;
    final tomorrowWeekday = tomorrow.weekday;

    totalTrashTypeOfTomorrow = '無し';

    for (var i = 0; i < trashDayOfList.length; i++) {
      final trashDay = trashDayOfList[i];
      if (tomorrowWeekOfMonth == trashDay.weekOfMonth && tomorrowWeekday == trashDay.weekday) {
        totalTrashTypeOfTomorrow = trashDay.totalTrashType;
        print('明日のゴミ:$totalTrashTypeOfTomorrow');
        break;
      }
    }
    notifyListeners();
  }

  Future<String> getTotalTrashTypeOfToday() async {
    print('start setTotalTrashType');
    List<TrashOfDay> trashDayOfList = trashOfDayBoxRepository.getTrashOfDayList();

    final currentWeekOfMonth = (today.day ~/ 7) + 1;
    final currentWeekday = today.weekday;

    totalTrashTypeOfToday = '無し';

    for (var i = 0; i < trashDayOfList.length; i++) {
      final trashDay = trashDayOfList[i];
      if (currentWeekOfMonth == trashDay.weekOfMonth && currentWeekday == trashDay.weekday) {
        totalTrashTypeOfToday = trashDay.totalTrashType;
        print('今日のゴミ:$totalTrashTypeOfToday');
        break;
      }
    }

    return totalTrashTypeOfToday;
  }

  Future<String> getTotalTrashTypeOfTomorrow() async {
    print('start setTotalTrashType');
    List<TrashOfDay> trashDayOfList = trashOfDayBoxRepository.getTrashOfDayList();

    final tomorrowWeekOfMonth = (tomorrow.day ~/ 7) + 1;
    final tomorrowWeekday = tomorrow.weekday;

    totalTrashTypeOfTomorrow = '無し';

    for (var i = 0; i < trashDayOfList.length; i++) {
      final trashDay = trashDayOfList[i];
      if (tomorrowWeekOfMonth == trashDay.weekOfMonth && tomorrowWeekday == trashDay.weekday) {
        totalTrashTypeOfTomorrow = trashDay.totalTrashType;
        print('明日のゴミ:$totalTrashTypeOfTomorrow');
        break;
      }
    }

    return totalTrashTypeOfTomorrow;
  }
}
