import 'package:hive_flutter/hive_flutter.dart';

part 'trashDay.g.dart';

@HiveType(typeId: 1)
class TrashDay {
  @HiveField(0)
  String id;

  @HiveField(1)
  String trashType;

  @HiveField(2)
  Map<int, bool> weekdays;

  @HiveField(3)
  Map<int, bool> weeks;

  TrashDay({
    required this.id,
    required this.trashType,
    required this.weekdays,
    required this.weeks,
  });
}
