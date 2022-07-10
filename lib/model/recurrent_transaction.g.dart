// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrent_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurrentTransactionAdapter extends TypeAdapter<RecurrentTransaction> {
  @override
  final int typeId = 1;

  @override
  RecurrentTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurrentTransaction()
      ..name = fields[0] as String
      ..lastUpdate = fields[1] as DateTime
      ..category = fields[2] as String
      ..amount = fields[3] as double
      ..note = fields[4] == null ? '' : fields[4] as String
      ..frequency = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, RecurrentTransaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lastUpdate)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.frequency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrentTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
