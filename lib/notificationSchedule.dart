import 'package:trash_out/typeAdapter/trashDay.dart';

// enum whichDay{
//   today(1),
//   tomorrow()
// }

class Notification {
  DateTime currentTime = DateTime.now();
  Enum whichDay;
  // int currentWeekday = currentTime.weekday;
  String messageTrashType = '';
  String notifyMessage = '';

  Notification(this.whichDay) {}

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
      if (justifyOrdinalNumbers(trashDay)) {
        if (justifyWeekDay(trashDay)) {
          messageTrashType += trashDay.trashType;
        }
      }
    }
    return messageTrashType;
  }

  bool justifyOrdinalNumbers(TrashDay trashDay) {
    List ordinalNumbersList = mapToList(trashDay.ordinalNumbers);
    bool result = false;
    for (var i = 0; i < ordinalNumbersList.length; i++) {
      if (currentTime.day / 7 == trashDay.ordinalNumbers[i]) {
        result = true;
        break;
      }
    }
    return result;
  }

  bool justifyWeekDay(TrashDay trashDay) {
    List weekdayList = mapToList(trashDay.daysOfTheWeek);
    bool result = false;
    for (var i = 0; i < weekdayList.length; i++) {
      if (currentTime.weekday == trashDay.daysOfTheWeek[i]) {
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
