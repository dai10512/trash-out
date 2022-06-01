import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'trashDay.g.dart';

@HiveType(typeId: 1)
class TrashDay {
  @HiveField(0)
  String id;

  @HiveField(1)
  String trashType;

  @HiveField(2)
  Map<int, bool> daysOfTheWeek;

  @HiveField(3)
  Map<int, bool> ordinalNumbers;

  TrashDay({
    required this.id,
    required this.trashType,
    required this.daysOfTheWeek,
    required this.ordinalNumbers,
  });
}
