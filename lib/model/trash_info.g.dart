// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TrashInfo _$$_TrashInfoFromJson(Map<String, dynamic> json) => _$_TrashInfo(
      id: json['id'] as String,
      trashType: json['trashType'] as String,
      daysOfWeek: (json['daysOfWeek'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as bool),
      ),
      weeksOfMonth: (json['weeksOfMonth'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as bool),
      ),
    );

Map<String, dynamic> _$$_TrashInfoToJson(_$_TrashInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trashType': instance.trashType,
      'daysOfWeek':
          instance.daysOfWeek.map((k, e) => MapEntry(k.toString(), e)),
      'weeksOfMonth':
          instance.weeksOfMonth.map((k, e) => MapEntry(k.toString(), e)),
    };
