// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trashDayNotification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrashDayNotificationAdapter extends TypeAdapter<TrashDayNotification> {
  @override
  final int typeId = 2;

  @override
  TrashDayNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrashDayNotification(
      whichDay: fields[0] as int,
      time: fields[1] as TimeOfDay,
      doNotify: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TrashDayNotification obj) {
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
      other is TrashDayNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
