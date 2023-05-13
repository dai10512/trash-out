// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash_of_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TrashOfDay _$$_TrashOfDayFromJson(Map<String, dynamic> json) =>
    _$_TrashOfDay(
      targetDay: $enumDecode(_$TargetDayEnumMap, json['targetDay']),
      trashType: json['trashType'] as String,
    );

Map<String, dynamic> _$$_TrashOfDayToJson(_$_TrashOfDay instance) =>
    <String, dynamic>{
      'targetDay': _$TargetDayEnumMap[instance.targetDay]!,
      'trashType': instance.trashType,
    };

const _$TargetDayEnumMap = {
  TargetDay.today: 'today',
  TargetDay.tomorrow: 'tomorrow',
};
