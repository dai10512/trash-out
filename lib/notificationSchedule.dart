import 'package:trash_out/typeAdapter/trashDay.dart';

class LocalNotification {
  DateTime currentTime = DateTime.now();
  int whichDay;
  String messageTrashType = '';
  String notifyMessage = '';

  LocalNotification(this.whichDay) {}

  String createNotifyMessage(List<TrashDay> trashDays) {
    String notifyMessage = '';
    final targetTrashType = getTargetTrashType(trashDays);
    if (targetTrashType == '') {
      notifyMessage = '本日のゴミ出しはありません';
    } else {
      notifyMessage = '本日のゴミ出しは、$targetTrashTypeです';
    }
    return notifyMessage;
  }

  String getTargetTrashType(List<TrashDay> trashDays) {
    messageTrashType = '';
    for (var i = 0; i < trashDays.length; i++) {
      final trashDay = trashDays[i];
      if (justifyWeeks(trashDay)) {
        if (justifyWeekDay(trashDay)) {
          messageTrashType += trashDay.trashType;
        }
      }
    }
    return messageTrashType;
  }

  bool justifyWeeks(TrashDay trashDay) {
    List weeksList = mapToList(trashDay.weeks);
    bool result = false;
    for (var i = 0; i < weeksList.length; i++) {
      if (currentTime.day / 7 == trashDay.weeks[i]) {
        result = true;
        break;
      }
    }
    return result;
  }

  bool justifyWeekDay(TrashDay trashDay) {
    List weekdayList = mapToList(trashDay.weekdays);
    bool result = false;
    for (var i = 0; i < weekdayList.length; i++) {
      if (currentTime.weekday == trashDay.weekdays[i]) {
        result = true;
        break;
      }
    }
    return result;
  }

  List mapToList(Map map) {
    final List keys = [];
    for (var i = 1; i <= map.length; i++) {
      if (map[i]) {
        keys.add(i);
      }
    }
    return keys;
  }
}
