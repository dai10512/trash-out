// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trashDay.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrashDayAdapter extends TypeAdapter<TrashDay> {
  @override
  final int typeId = 1;

  @override
  TrashDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrashDay(
      id: fields[0] as String,
      trashType: fields[1] as String,
      weekdays: (fields[2] as Map).cast<int, bool>(),
      weeks: (fields[3] as Map).cast<int, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, TrashDay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.trashType)
      ..writeByte(2)
      ..write(obj.weekdays)
      ..writeByte(3)
      ..write(obj.weeks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrashDayAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
