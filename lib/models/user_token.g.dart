// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTokenAdapter extends TypeAdapter<UserToken> {
  @override
  final typeId = 0;

  @override
  UserToken read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserToken(
      tokenType: fields[0] as String,
      expiresIn: fields[1] as int,
      accessToken: fields[2] as String,
      refreshToken: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserToken obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tokenType)
      ..writeByte(1)
      ..write(obj.expiresIn)
      ..writeByte(2)
      ..write(obj.accessToken)
      ..writeByte(3)
      ..write(obj.refreshToken);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserToken _$UserTokenFromJson(Map<String, dynamic> json) {
  return UserToken(
    tokenType: json['token_type'] as String,
    expiresIn: json['expires_in'] as int,
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
  );
}

Map<String, dynamic> _$UserTokenToJson(UserToken instance) => <String, dynamic>{
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
