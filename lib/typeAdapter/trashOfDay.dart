import 'package:hive_flutter/hive_flutter.dart';

part 'trashOfDay.g.dart';

@HiveType(typeId: 3)
class TrashOfDay {
  @HiveField(0)
  String totalTrashType;

  @HiveField(1)
  int weekday;

  @HiveField(2)
  int weekOfMonth;

  TrashOfDay({
    required this.totalTrashType,
    required this.weekday,
    required this.weekOfMonth,
  });
}