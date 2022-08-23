// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stored.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStoreAdapter extends TypeAdapter<UserStore> {
  @override
  final int typeId = 0;

  @override
  UserStore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStore()
      ..username = fields[0] as String
      ..id = fields[1] as String
      ..qr = fields[2] as String
      ..email = fields[3] as String
      ..route = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, UserStore obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.qr)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.route);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
