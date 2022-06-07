// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationSetting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingAdapter extends TypeAdapter<NotificationSetting> {
  @override
  final int typeId = 2;

  @override
  NotificationSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSetting(
      whichDay: fields[0] as int,
      time: fields[1] as TimeOfDay,
      doNotify: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSetting obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.whichDay)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.doNotify);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
