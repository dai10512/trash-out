import 'package:hive_flutter/hive_flutter.dart';

part 'trash.g.dart';

@HiveType(typeId: 1)
class Trash {


  @HiveField(0)
  String trashType;

  @HiveField(1)
  Map<int, bool> weekdays;

  @HiveField(2)
  Map<int, bool> weeksOfMonth;

  Trash({
    required this.trashType,
    required this.weekdays,
    required this.weeksOfMonth,
  });
}
