// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrashAdapter extends TypeAdapter<Trash> {
  @override
  final int typeId = 1;

  @override
  Trash read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trash(
      trashType: fields[0] as String,
      weekdays: (fields[1] as Map).cast<int, bool>(),
      weeksOfMonth: (fields[2] as Map).cast<int, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, Trash obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.trashType)
      ..writeByte(1)
      ..write(obj.weekdays)
      ..writeByte(2)
      ..write(obj.weeksOfMonth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrashAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
