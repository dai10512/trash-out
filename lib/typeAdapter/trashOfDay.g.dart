// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TrashOfDay.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrashOfDayAdapter extends TypeAdapter<TrashOfDay> {
  @override
  final int typeId = 3;

  @override
  TrashOfDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrashOfDay(
      totalTrashType: fields[0] as String,
      weekday: fields[1] as int,
      weekOfMonth: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TrashOfDay obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.totalTrashType)
      ..writeByte(1)
      ..write(obj.weekday)
      ..writeByte(2)
      ..write(obj.weekOfMonth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrashOfDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
